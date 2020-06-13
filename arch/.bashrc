# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\[\033[1;32m\]\u\[\033[0m\]:\[\033[1;34m\]\W\[\033[1;34m\]\[\033[0m\]] \$ '

# key bindings
alias r="ranger"
alias v="nvim"
alias sdn="shutdown now"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
