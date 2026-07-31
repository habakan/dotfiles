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

### Set up skills on a new machine
```bash
git clone git@github.com:habakan/skills.git ~/work/skills   # own skills
apm install                                                 # external skills only
make skills                                                 # symlink both into the clients
```

## Skills

Own skills and external skills are managed separately. They are authored once and used by
both Claude Code and Codex.

- **Own skills**: `~/work/skills` (clone of `habakan/skills`). **Edit here directly** —
  `make skills` symlinks each skill into `~/.claude/skills/` and `~/.codex/skills/`, so a
  save takes effect immediately. No build step, no copies. Commit and push in that clone.
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

- `.gitconfig` - Git user configuration
- `.tmux.conf` - tmux configuration (prefix key: C-t)
- `.vimrc` - Vim configuration
- `.config/nvim/init.lua` - Neovim configuration (Lua)
- `apm.yml` / `apm.lock.yaml` - APM manifest and lockfile (external skills only)
- `Makefile` - Deployment automation
- `etc/init/*.sh` - Initialization scripts (executed by `make init`)
