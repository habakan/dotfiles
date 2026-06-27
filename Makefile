DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml .config .github .apm .agents .claude .codex
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@ln -sfnv $(abspath tmux) $(HOME)/.tmux
	@mkdir -p $(HOME)/.config
	@$(foreach val, $(wildcard config/*), ln -sfnv $(abspath $(val)) $(HOME)/.config/$(notdir $(val));)
	@mkdir -p $(HOME)/.claude/commands
	@$(foreach val, $(wildcard claude/commands/*), ln -sfnv $(abspath $(val)) $(HOME)/.claude/commands/$(notdir $(val));)
	@ln -sfnv $(abspath claude/settings.json) $(HOME)/.claude/settings.json
	@ln -sfnv $(abspath claude/settings.local.json) $(HOME)/.claude/settings.local.json
	@mkdir -p $(HOME)/.claude/skills
	@$(foreach val, $(wildcard .claude/skills/*), ln -sfnv $(abspath $(val)) $(HOME)/.claude/skills/$(notdir $(val));)
	@mkdir -p $(HOME)/.codex/skills
	@$(foreach val, $(wildcard .agents/skills/*), ln -sfnv $(abspath $(val)) $(HOME)/.codex/skills/$(notdir $(val));)

init:
	@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)
