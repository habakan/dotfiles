# Enable Powerlevel10k instant prompt (should stay at the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Performance optimizations
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# History settings
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=10000

# Plugins
# Note: zsh-autosuggestions and zsh-syntax-highlighting require separate installation
plugins=(
  git
  docker
  kubectl
  history
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias vim='nvim'
alias v='nvim'
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -10'

# Functions
# Review a GitHub PR in hunk without checking it out.
# Usage: hunk-pr 123 / hunk-pr 123 --repo owner/repo
hunk-pr() {
    gh pr diff "$1" --patch "${@:2}" | hunk patch -
}

# リモートでは既定の local だと keys.command がサーバーに届かず prefix+f が動かない
# Usage: hr gpu1 / hr nkb
hr() {
    herdr --remote "$1" --remote-keybindings server "${@:2}"
}

# Load Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Sync dotfiles on login (background)
(
  cd ~/dotfiles 2>/dev/null &&
  git fetch -q origin main &&
  if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
    make update
  fi
) &>/dev/null &

export PATH="$HOME/.local/bin:$PATH"
export GPG_TTY=$(tty)

# dotfiles/bin (deploy で ~/bin に張る)
export PATH="$HOME/bin:$PATH"

# Load local settings (machine-specific PATH, env vars, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# ~/.zshrc.local の PATH 追加より後に有効化する。先に有効化すると Homebrew などが mise より前に来る
command -v mise >/dev/null && eval "$(mise activate zsh)"
