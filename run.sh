#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Helper function for colored output
log() {
  echo -e "\033[1;32m[SCRIPT]\033[0m $1"
}

# 1. Check if Ansible is installed
if ! command -v ansible &>/dev/null; then
  log "Ansible not found. Detecting distribution..."
  source /etc/os-release

  if [[ "$ID" == "arch" || "$ID" == "cachyos" || "$ID_LIKE" == *"arch"* ]]; then
    log "Arch/CachyOS detected. Installing Ansible via pacman..."
    sudo pacman -S --noconfirm ansible
  elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"ubuntu"* ]]; then
    log "Ubuntu detected. Installing Ansible via PPA..."
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
  else
    echo "Error: Unsupported distribution for automatic installation."
    exit 1
  fi
else
  log "Ansible is already installed."
fi

# 2. Check/Install kewlfft.aur collection (Arch/CachyOS only)
source /etc/os-release
if [[ "$ID" == "arch" || "$ID" == "cachyos" || "$ID_LIKE" == *"arch"* ]]; then
  if ! ansible-galaxy collection list | grep -q "kewlfft.aur"; then
    log "Installing kewlfft.aur collection..."
    ansible-galaxy collection install kewlfft.aur
  else
    log "Collection kewlfft.aur is already installed."
  fi
fi

# 3. Handle Dotfiles Git Repository
DOTFILES_DIR="$HOME/dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
  log "Checking $DOTFILES_DIR..."
  cd "$DOTFILES_DIR"

  # Check for uncommitted changes (staged or unstaged)
  if [[ -n $(git status --porcelain) ]]; then
    log "Uncommitted changes found. Committing..."
    git add .
    git commit -m "Uncommited changes before running playbook"
  fi

  # Check for unpushed changes
  if [[ -n $(git log --branches --not --remotes) ]]; then
    log "Unpushed changes found. Pushing..."
    git push
  fi

  cd - >/dev/null
else
  log "Directory ~/dotfiles does not exist. Skipping git checks."
fi

# 4. Execute Remote Playbook
log "Downloading and executing playbook..."
PLAYBOOK_URL="https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/playbook.yml"
TEMP_PLAYBOOK=$(mktemp)

# Download the playbook to a temp file
curl -sSL "$PLAYBOOK_URL" -o "$TEMP_PLAYBOOK"

# Run the playbook
ansible-playbook "$TEMP_PLAYBOOK" --ask-become-pass

# Cleanup
rm "$TEMP_PLAYBOOK"
log "Done."
