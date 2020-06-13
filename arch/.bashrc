# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Default applications
export VISUAL=nvim;
export EDITOR=nvim;

# Path
export PATH=/home/aditya/scripts:$PATH

# Prompt
PS1='[\[\033[1;32m\]\u\[\033[0m\]:\[\033[1;34m\]\W\[\033[1;34m\]\[\033[0m\]] \$ '

# Aliases
alias ls='ls --color=auto'
alias r="ranger"
alias v="nvim"
alias sdn="shutdown now"
alias br="sudo brightness.sh"

alias spsyu='sudo pacman -Syu'
alias sps='sudo pacman -S'
alias spr='sudo pacman -R'


# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
