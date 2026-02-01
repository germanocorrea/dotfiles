#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"
export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.cargo/bin/:~/.local/bin
export NVM_DIR="$HOME/.nvm"
export GTK_USE_PORTAL=1
export GDK_DEBUG=portals
export QT_QPA_PLATFORMTHEME=xdgdesktopportal
