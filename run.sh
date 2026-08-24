#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# NOTE: This script must stay POSIX-sh compatible (no [[ ]], no &>, no echo -e),
# because it may be executed via "sh -c" (dash on Ubuntu), which ignores the shebang.

# Helper function for colored output
log() {
  printf '\033[1;32m[SCRIPT]\033[0m %s\n' "$1"
}

# True if $1 equals $ID or any entry of $ID_LIKE (from /etc/os-release)
distro_is() {
  for d in "$ID" ${ID_LIKE:-}; do
    [ "$d" = "$1" ] && return 0
  done
  return 1
}

# 1. Check if Ansible is installed
if ! command -v ansible >/dev/null 2>&1; then
  log "Ansible not found. Detecting distribution..."
  . /etc/os-release

  if distro_is arch || distro_is cachyos; then
    log "Arch/CachyOS detected. Installing Ansible via pacman..."
    sudo pacman -S --noconfirm ansible
  elif distro_is ubuntu || distro_is debian; then
    log "Ubuntu/Debian detected. Installing Ansible via apt..."
    # Requires the "universe" component (enabled by default on standard installs)
    sudo apt update
    sudo apt install -y ansible
  else
    echo "Error: Unsupported distribution for automatic installation."
    exit 1
  fi
else
  log "Ansible is already installed."
fi

# 2. Check/Install kewlfft.aur collection (Arch/CachyOS only)
. /etc/os-release
if distro_is arch || distro_is cachyos; then
  if ! ansible-galaxy collection list | grep -q "kewlfft.aur"; then
    log "Installing kewlfft.aur collection..."
    ansible-galaxy collection install kewlfft.aur
  else
    log "Collection kewlfft.aur is already installed."
  fi
fi

# 3. Handle Dotfiles Git Repository
DOTFILES_DIR="$HOME/dotfiles"
REPO_HTTPS="https://github.com/germanocorrea/dotfiles.git"

if [ ! -d "$DOTFILES_DIR" ]; then
  log "Cloning dotfiles repository from $REPO_HTTPS..."
  git clone "$REPO_HTTPS" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Check for uncommitted changes (staged or unstaged)
if [ -n "$(git status --porcelain)" ]; then
  log "Uncommitted changes found. Committing..."
  git add .
  git commit -m "Uncommited changes before running playbook"
fi

# Check for unpushed changes
if [ -n "$(git log --branches --not --remotes)" ]; then
  log "Unpushed changes found. Pushing..."
  git push
fi

# 4. Execute Playbook
log "Detecting OS for playbook selection..."
. /etc/os-release

if distro_is arch || distro_is cachyos; then
  PLAYBOOK_PATH="ansible/playbook_arch.yml"
elif distro_is ubuntu || distro_is debian; then
  PLAYBOOK_PATH="ansible/playbook_ubuntu.yml"
else
  echo "Error: Unsupported distribution for playbook execution."
  exit 1
fi

log "Executing local playbook: $PLAYBOOK_PATH..."
ansible-playbook "$PLAYBOOK_PATH" --ask-become-pass

log "Done."
