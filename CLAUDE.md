# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository for managing personal configuration files. It uses symbolic links to deploy configuration files from this repository to the home directory.

## Commands

### Deploy dotfiles to home directory
```bash
make deploy
```
This creates symbolic links for all dotfiles in the home directory. Files under `.config/` are linked to `~/.config/`.

### Run initialization scripts
```bash
make init
```
This executes all shell scripts in `./etc/init/`.

### Set up / update skills (APM)
```bash
git submodule update --init --recursive   # fetch the skills submodule
apm install                               # regenerate .claude/skills + .agents/skills
make deploy                               # symlink them into ~/.claude/skills and ~/.codex/skills
```

## Skills (managed via microsoft/apm)

Skills are authored once and deployed cross-client (Claude Code + Codex).

- **Source of truth**: `.apm/skills/` (git submodule -> `habakan/skills`). Edit skills here.
- **apm.yml**: declares `targets: [claude, codex]` and external skill packages
  (`dependencies.apm`). `apm install` walks `.apm/skills/` (via `includes: auto`) and
  deploys to both client dirs.
- **Generated (gitignored)**: `.claude/skills/` (Claude reads this) and `.agents/skills/`
  (Codex and other agentskills.io clients read this). Regenerate with `apm install`.
- **Deploy**: `make deploy` symlinks `.claude/skills/*` -> `~/.claude/skills/` and
  `.agents/skills/*` -> `~/.codex/skills/`.

Workflow to add/edit a skill: edit under `.apm/skills/` (commit & push the submodule),
then `apm install && make deploy`.

Using a skill in another project for Codex: in that repo run
`apm install habakan/skills/<name> -t codex` and commit `.agents/skills/`.

## Structure

- `.gitconfig` - Git user configuration
- `.tmux.conf` - tmux configuration (prefix key: C-t)
- `.vimrc` - Vim configuration
- `.config/nvim/init.lua` - Neovim configuration (Lua)
- `.apm/skills/` - Skills submodule (`habakan/skills`); APM source of truth
- `apm.yml` / `apm.lock.yaml` - APM manifest and lockfile
- `Makefile` - Deployment automation
- `etc/init/*.sh` - Initialization scripts (executed by `make init`)
