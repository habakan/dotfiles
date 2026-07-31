DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml .config .github .apm .agents .claude .codex
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

# エージェント設定 (habakan/agent-config, private submodule)
AGENT_DIR    := agent-config

# 自作スキルの source of truth (habakan/skills の clone)。
# ここを直接編集すれば symlink 経由で Claude / Codex に即反映される。
SKILLS_DIR   := $(HOME)/work/skills
# SKILL.md を持つ top-level ディレクトリ + meta/ 配下
SKILLS_OWN   := $(patsubst %/,%,$(dir $(wildcard $(SKILLS_DIR)/*/SKILL.md) $(wildcard $(SKILLS_DIR)/meta/*/SKILL.md)))
# apm が取得する外部スキル (自作は通さない)
SKILLS_CLAUDE_EXT := $(wildcard .claude/skills/*)
SKILLS_CODEX_EXT  := $(wildcard .agents/skills/*)

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@ln -sfnv $(abspath tmux) $(HOME)/.tmux
	@mkdir -p $(HOME)/.config
	@$(foreach val, $(wildcard config/*), ln -sfnv $(abspath $(val)) $(HOME)/.config/$(notdir $(val));)
	@$(MAKE) --no-print-directory agents
	@$(MAKE) --no-print-directory skills

# agents: エージェント設定。実体は private の agent-config submodule。
# 公開している dotfiles には中身を置かない。
# 共有は AGENTS.md のみ。settings/hooks はスキーマが違うためクライアント別。
# Claude Code は AGENTS.md を読まないので claude/CLAUDE.md 経由で @import する。
agents:
	@mkdir -p $(HOME)/.claude/commands $(HOME)/.codex
	@$(foreach val, $(wildcard $(AGENT_DIR)/claude/commands/*), ln -sfnv $(abspath $(val)) $(HOME)/.claude/commands/$(notdir $(val));)
	@ln -sfnv $(abspath $(AGENT_DIR)/AGENTS.md) $(HOME)/.codex/AGENTS.md
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/CLAUDE.md) $(HOME)/.claude/CLAUDE.md
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/settings.json) $(HOME)/.claude/settings.json
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/settings.local.json) $(HOME)/.claude/settings.local.json
	@ln -sfnv $(abspath $(AGENT_DIR)/claude/hooks) $(HOME)/.claude/hooks
	@ln -sfnv $(abspath $(AGENT_DIR)/codex/hooks.json) $(HOME)/.codex/hooks.json
	@ln -sfnv $(abspath $(AGENT_DIR)/codex/hooks) $(HOME)/.codex/hooks

# skills: 自作(SKILLS_DIR から直接) + 外部(apm 生成物) を各クライアントへ symlink する。
# ~/.claude/skills と ~/.codex/skills は実ディレクトリのまま保つ。
# ディレクトリ自体を symlink にすると他ツールのインストーラが書き込めなくなるため。
skills: skills-prune
	@mkdir -p $(HOME)/.claude/skills $(HOME)/.codex/skills
	@$(foreach val, $(SKILLS_OWN), \
		ln -sfnv $(val) $(HOME)/.claude/skills/$(notdir $(val)); \
		ln -sfnv $(val) $(HOME)/.codex/skills/$(notdir $(val));)
	@$(foreach val, $(SKILLS_CLAUDE_EXT), ln -sfnv $(abspath $(val)) $(HOME)/.claude/skills/$(notdir $(val));)
	@$(foreach val, $(SKILLS_CODEX_EXT), ln -sfnv $(abspath $(val)) $(HOME)/.codex/skills/$(notdir $(val));)

# 参照先が消えた symlink を掃除する(実ディレクトリには触れない)
skills-prune:
	@$(foreach d, $(HOME)/.claude/skills $(HOME)/.codex/skills, \
		[ -d $(d) ] && find $(d) -maxdepth 1 -type l -exec sh -c \
			'[ -e "$$1" ] || { echo "prune $$1"; rm "$$1"; }' _ {} \; ;)

init:
	@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)

.PHONY: deploy init agents skills skills-prune
