export ZSH="/home/aditya/.oh-my-zsh"

export VISUAL=nvim;
export EDITOR=nvim;
export BROWSER=brave;

ZSH_THEME="bira"

plugins=(
  git
  dotenv
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# ls
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias lal="ls -la"

# programs
alias r="ranger"
alias v="nvim"
alias nb="newsboat"
alias x="xdg-open"

# commands
alias sdn="shutdown now"
alias br="sudo brightness.sh"
alias spsyu='sudo pacman -Syu'
alias sps='sudo pacman -S'
alias spr='sudo pacman -R'

# Load nvm
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
