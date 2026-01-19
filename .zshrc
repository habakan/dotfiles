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

# Load Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Load local settings (machine-specific PATH, env vars, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
