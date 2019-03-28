#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\e[0;36m\u@\h \W > \e[m'

# key bindings
alias r="ranger"
alias c="cmus"
alias cb="bash /home/aditya/brightness.sh"
