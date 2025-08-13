# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='eza'
alias grep='grep --color=auto'
alias vim=nvim
alias vi=nvim
alias c=clear
alias ls=eza
alias ll='eza -l'
alias la='eza -la'
alias lla='eza -lla'
alias cat=bat
alias zz='z -'

# Starship
eval "$(starship init bash)"

# Zoxide
eval "$(zoxide init bash)"

export EDITOR=nvim

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
