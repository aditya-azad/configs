#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias lsa='ls -a --color=auto'
alias lsl='ls -l --color=auto'
alias lsal='ls -al --color=auto'

alias r='ranger'
alias v='nvim'
alias e='emacs'
alias sdn='shutdown now'
alias nb='newsboat'
alias sx='startx'

PS1="\[\033[38;5;2m\][\u@\H] \w\n> \[$(tput sgr0)\]"

export CONFIGS_HOME="$HOME/Documents/configs"
export PATH=$HOME/.local/share/dwmblocksscripts:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
