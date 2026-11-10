#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -r /etc/os-release ]] && . /etc/os-release
DISTRO="${ID:-unknown}"

. "$HOME/.cargo/env"
export EDITOR=emacsclient
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.cargo/bin/:~/.local/bin
export NVM_DIR="$HOME/.nvm"
export GTK_USE_PORTAL=1
export GDK_DEBUG=portals
export QT_QPA_PLATFORMTHEME=xdgdesktopportal

# Distro-specific configuration. See .bashrc_arch / .bashrc_ubuntu.
[[ -r "$HOME/.bashrc_${DISTRO}" ]] && . "$HOME/.bashrc_${DISTRO}"
