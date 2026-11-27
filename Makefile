DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml .config .github .apm .agents .claude .codex
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_DIR      := $(CURDIR)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

# エージェント設定 (habakan/agent-config, private submodule)
AGENT_DIR    := agent-config

# 自作スキルの source of truth (habakan/skills の clone)。
# ここを直接編集すれば symlink 経由で Claude / Codex に即反映される。
SKILLS_DIR   := $(HOME)/work/skills
# SKILL.md を持つ top-level ディレクトリ + meta/・bot/ 配下
SKILLS_OWN   := $(patsubst %/,%,$(dir $(wildcard $(SKILLS_DIR)/*/SKILL.md) $(wildcard $(SKILLS_DIR)/meta/*/SKILL.md) $(wildcard $(SKILLS_DIR)/bot/*/SKILL.md)))
# apm が取得する外部スキル (自作は通さない)
SKILLS_CLAUDE_EXT := $(wildcard .claude/skills/*)
SKILLS_CODEX_EXT  := $(wildcard .agents/skills/*)

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@ln -sfnv $(abspath tmux) $(HOME)/.tmux
	@mkdir -p $(HOME)/.config
# リンク先が実ディレクトリだと ln -sfn はその中にリンクを張り、設定が読まれなくなる
# (herdr が先に ~/.config/herdr を作っていた環境で発生)。そこだけ張らずに警告する。
	@$(foreach val, $(wildcard config/*), \
		if [ -d $(HOME)/.config/$(notdir $(val)) ] && [ ! -L $(HOME)/.config/$(notdir $(val)) ]; then \
			echo "skip $(HOME)/.config/$(notdir $(val)): 実ディレクトリのため symlink を張らない"; \
		else ln -sfnv $(abspath $(val)) $(HOME)/.config/$(notdir $(val)); fi;)
	@$(MAKE) --no-print-directory loaders
	@$(MAKE) --no-print-directory agents
	@$(MAKE) --no-print-directory skills

# ~/.zshrc と ~/.gitconfig は symlink にせず、repo 側を読み込む実ファイルにする。
# インストーラや git config --global の追記が repo に入り、pull を止めるため。
loaders:
	@[ ! -L $(HOME)/.zshrc ] || rm $(HOME)/.zshrc
	@grep -qxF 'source $(DOTFILES_DIR)/zshrc' $(HOME)/.zshrc 2>/dev/null || \
		{ { echo 'source $(DOTFILES_DIR)/zshrc'; cat $(HOME)/.zshrc 2>/dev/null || true; } > $(HOME)/.zshrc.new && mv $(HOME)/.zshrc.new $(HOME)/.zshrc; }
	@[ ! -L $(HOME)/.gitconfig ] || rm $(HOME)/.gitconfig
	@grep -qF 'path = $(DOTFILES_DIR)/gitconfig' $(HOME)/.gitconfig 2>/dev/null || \
		{ { printf '[include]\n\tpath = %s/gitconfig\n' '$(DOTFILES_DIR)'; cat $(HOME)/.gitconfig 2>/dev/null || true; } > $(HOME)/.gitconfig.new && mv $(HOME)/.gitconfig.new $(HOME)/.gitconfig; }

# リモートホストで main に追従する。agent-config に権限がないホストでは submodule の失敗を無視する。
update:
	git pull --ff-only
	-git submodule update --init
	-@$(MAKE) --no-print-directory tools
	@$(MAKE) --no-print-directory deploy

# config/mise のツールを入れる。mise が無ければ公式インストーラで ~/.local/bin に入れる (root 不要)。
tools:
	@command -v mise >/dev/null || [ -x $(HOME)/.local/bin/mise ] || curl -fsSL https://mise.run | sh
	@PATH=$(HOME)/.local/bin:$$PATH mise install

# agents: エージェント設定。実体は private の agent-config submodule。
# 公開している dotfiles には中身を置かない。
# 共有は AGENTS.md のみ。settings/hooks はスキーマが違うためクライアント別。
# Claude Code は AGENTS.md を読まないので claude/CLAUDE.md 経由で @import する。
agents:
	@mkdir -p $(HOME)/.claude/commands $(HOME)/.codex $(HOME)/.gemini/config
	@$(foreach val, $(wildcard $(AGENT_DIR)/claude/commands/*), ln -sfnv $(abspath $(val)) $(HOME)/.claude/commands/$(notdir $(val));)
	@ln -sfnv $(abspath $(AGENT_DIR)/AGENTS.md) $(HOME)/.codex/AGENTS.md
	@ln -sfnv $(abspath $(AGENT_DIR)/AGENTS.md) $(HOME)/.gemini/config/AGENTS.md
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/CLAUDE.md) $(HOME)/.claude/CLAUDE.md
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/settings.json) $(HOME)/.claude/settings.json
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/settings.local.json) $(HOME)/.claude/settings.local.json
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/hooks) $(HOME)/.claude/hooks
# 実ファイルなら上書きしない。gpu1 / nkb はホスト固有の provider 設定を持つ。
	@if [ -f $(HOME)/.codex/config.toml ] && [ ! -L $(HOME)/.codex/config.toml ]; then \
		echo "skip $(HOME)/.codex/config.toml: 実ファイルのため symlink を張らない"; \
	else chmod 600 $(AGENT_DIR)/codex/config.toml && ln -sfnv $(abspath $(AGENT_DIR)/codex/config.toml) $(HOME)/.codex/config.toml; fi
	@ln -sfnv $(abspath $(AGENT_DIR)/codex/hooks.json) $(HOME)/.codex/hooks.json
	@ln -sfnv $(abspath $(AGENT_DIR)/codex/hooks) $(HOME)/.codex/hooks

# skills: 自作(SKILLS_DIR から直接) + 外部(apm 生成物) を各クライアントへ symlink する。
# ~/.claude/skills と ~/.codex/skills と ~/.gemini/config/skills は実ディレクトリのまま保つ。
# ディレクトリ自体を symlink にすると他ツールのインストーラが書き込めなくなるため。
# 外部を先に張り、自作で上書きする。名前が衝突しても自作(SKILLS_DIR)が勝つ。
skills: skills-prune
	@mkdir -p $(HOME)/.claude/skills $(HOME)/.codex/skills $(HOME)/.gemini/config/skills
	@$(foreach val, $(SKILLS_CLAUDE_EXT), ln -sfnv $(abspath $(val)) $(HOME)/.claude/skills/$(notdir $(val));)
	@$(foreach val, $(SKILLS_CODEX_EXT), \
		ln -sfnv $(abspath $(val)) $(HOME)/.codex/skills/$(notdir $(val)); \
		ln -sfnv $(abspath $(val)) $(HOME)/.gemini/config/skills/$(notdir $(val));)
	@$(foreach val, $(SKILLS_OWN), \
		ln -sfnv $(val) $(HOME)/.claude/skills/$(notdir $(val)); \
		ln -sfnv $(val) $(HOME)/.codex/skills/$(notdir $(val)); \
		ln -sfnv $(val) $(HOME)/.gemini/config/skills/$(notdir $(val));)

# 参照先が消えた symlink を掃除する(実ディレクトリには触れない)
skills-prune:
	@$(foreach d, $(HOME)/.claude/skills $(HOME)/.codex/skills $(HOME)/.gemini/config/skills, \
		if [ -d $(d) ]; then find $(d) -maxdepth 1 -type l -exec sh -c \
			'[ -e "$$1" ] || { echo "prune $$1"; rm "$$1"; }' _ {} \; ; fi;)

init:
	@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)

.PHONY: deploy loaders update tools init agents skills skills-prune
