#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\e[0;36m\u@\h \w\n\\$ \e[m'


# key bindings
alias r="ranger"
alias c="cmus"
alias v="vim"
alias cb="bash /home/aditya/brightness.sh"
alias sdn="shutdown now"
