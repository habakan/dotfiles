# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository for managing personal configuration files. It uses symbolic links to deploy configuration files from this repository to the home directory.

## Commands

### Deploy dotfiles to home directory
```bash
make deploy
```
This creates symbolic links for all dotfiles in the home directory. Files under `config/` are linked to `~/.config/`.
`~/.zshrc` and `~/.gitconfig` are not symlinks: they are real files that load `zshrc` / `gitconfig`
from this repo, so installers and `git config --global` append there instead of into the repo.
Put machine-specific settings in `~/.zshrc.local` or directly in those files, never in the repo.

### Sync remote hosts
```bash
make update        # on the host: pull --ff-only, submodule update, make tools, deploy
make tools         # install mise (to ~/.local/bin, no root) and the CLIs in config/mise/config.toml
dotfiles-sync      # from the Mac: run `make update` on gpu1 and nkb over ssh
```

### Run initialization scripts
```bash
make init
```
This executes all shell scripts in `./etc/init/`.

### Set up skills on a new machine
```bash
git clone git@github.com:habakan/skills.git ~/work/skills   # own skills
apm install                                                 # external skills only
make skills                                                 # symlink both into the clients
```

## Agent configuration

**This repository is public. Do not put agent configuration content here.**

Claude Code, Codex, and Antigravity (agy) settings live in `agent-config/`, a private submodule
(`habakan/agent-config`). `make agents` symlinks them into `~/.claude`, `~/.codex`, and `~/.gemini/config`.
See that repo's README for the layout and for what is shared vs per-client.

Edit the files inside `agent-config/` and commit in that submodule — the parent
only tracks the pointer.

## Skills

Own skills and external skills are managed separately. They are authored once and used by
Claude Code, Codex, and Antigravity (agy).

- **Own skills**: `~/work/skills` (clone of `habakan/skills`). **Edit here directly** —
  `make skills` symlinks each skill into `~/.claude/skills/`, `~/.codex/skills/`, and
  `~/.gemini/config/skills/`, so a save takes effect immediately. No build step, no copies.
  Commit and push in that clone.
- **External skills**: declared in `apm.yml` under `dependencies.apm`. `apm install`
  fetches them into `.claude/skills/` and `.agents/skills/` (gitignored), which
  `make skills` also symlinks. `includes: []` keeps apm from touching own skills.
- **Layout**: top-level dirs with a `SKILL.md`, plus `meta/*`, are deployed. `make skills`
  also prunes symlinks whose target no longer exists.

Workflow to add/edit an own skill: edit under `~/work/skills/`, then commit & push there.
`make skills` is only needed when adding or removing a skill.

Using a skill in another project for Codex: in that repo run
`apm install habakan/skills/<name> -t codex` and commit `.agents/skills/`.

**Do not put skills back under `.apm/skills/` or route own skills through `apm install`.**
That produced three copies of every skill, and content that existed only in the generated
(gitignored) dirs was silently lost.

## Structure

- `gitconfig` - Git user configuration (included from `~/.gitconfig`)
- `zshrc` - zsh configuration (sourced from `~/.zshrc`)
- `.tmux.conf` - tmux configuration (prefix key: C-t)
- `.vimrc` - Vim configuration
- `.config/nvim/init.lua` - Neovim configuration (Lua)
- `apm.yml` / `apm.lock.yaml` - APM manifest and lockfile (external skills only)
- `Makefile` - Deployment automation
- `etc/init/*.sh` - Initialization scripts (executed by `make init`)
