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

## Structure

- `.gitconfig` - Git user configuration
- `.tmux.conf` - tmux configuration (prefix key: C-t)
- `.vimrc` - Vim configuration
- `.config/nvim/init.lua` - Neovim configuration (Lua)
- `Makefile` - Deployment automation
- `etc/init/*.sh` - Initialization scripts (executed by `make init`)
