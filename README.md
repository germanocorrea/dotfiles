# germanocorrea/dotfiles

My personal dotfiles for the machines and distros I use. Public because at the first setup after OS installation I might not have SSH configured.

## How this works

- Ansible is used to automate installation of several required packages I need for each dotfile (niri dotfiles require the niri package, waybar dotfiles require waybar, nvim dotfiles require nvim and several LSPs, etc)
- GNU Stow is used to apply the dotfiles for the current user

## Supported distros

| Distro | Playbook |
|---|---|
| Arch | `ansible/playbook_arch.yml` |
| Ubuntu (24.04) | `ansible/playbook_ubuntu.yml` |

Distro-specific zsh configuration lives in `~/.zshrc_arch` / `~/.zshrc_ubuntu`, sourced from `.zshrc` based on `/etc/os-release`. For example, fzf key-bindings differ per distro because Ubuntu ships an older fzf than Arch.

Most differences between Arch and Ubuntu involves configuring the whole desktop environment in Arch (Niri + Mako + Vicinae + xdg-portal-* + awww + swaylock + etc) and some personal applications (Zen Browser, etc). Ubuntu is focused mainly in configuring a development environment (nvim, doom emacs, LSPs, etc). Ubuntu even has an `ubuntu` branch because some dotfiles I still haven't made "distro aware" like ZSH, and they needed change (ex: I don't need org-mode in emacs in Ubuntu).

> IMPORTANT/KNOWN ISSUES:
> - Some configuration is missing from both and currently I'm lazy to add them. Eventually will, but this repo concentrates most of what I tend to customize the most.
> - I belive the way kewlfft.aur is configured or used in ansible is broken :)

First run:
```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/run.sh)"
```

After first run, an alias is configured for updating everything:
```sh
updateansible
```

## How run.sh works
- Detects the distribution (Arch/CachyOS or Ubuntu/Debian) and selects the matching playbook.
- Checks if Ansible and it's prerequisites are installed for applying the playbook.
  - For Arch/CachyOS, it installs through the distro's own repositories, and installs kewlfft.aur

- Check if there is a dotfiles directory already. If there is, it commits everything that is uncommited and pushes everything unpushed.
- Executes the playbook fetching it from github

## ToDo
[ ] Use Nix for development packages
[ ] Add missing packages
[ ] Fix usage of kewlfft.aur
