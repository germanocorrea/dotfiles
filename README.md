# germanocorrea/dotfiles

My personal dotfiles for the machines and distros I use. Public because at the first setup after OS installation I might not have SSH configured.

## Supported distros

| Distro | Playbook | Scope |
|---|---|---|
| Arch / CachyOS | `ansible/playbook_arch.yml` | Everything: base, development, neovim, doom, shell, terminal apps, python, plus personal/GUI apps (niri, waybar, virt-manager, AUR packages...) |
| Ubuntu (24.04) | `ansible/playbook_ubuntu.yml` | Development-only: base, development, neovim, doom, shell, terminal apps, python. No GUI/personal apps |

Distro-specific zsh configuration lives in `~/.zshrc_arch` / `~/.zshrc_ubuntu`, sourced from `.zshrc` based on `/etc/os-release`. For example, fzf key-bindings differ per distro because Ubuntu ships an older fzf than Arch.

### Ubuntu notes
- Neovim is installed via snap (`--classic`) because the apt version is too old for the current config.
- Requires the apt `universe` component (enabled by default on standard installs).
- Some tools have different binary names on Debian/Ubuntu; aliases are set in `~/.zshrc_ubuntu` (`bat` -> `batcat`, `fd` -> `fdfind`).
- `eza` comes from its official apt repository (not packaged in 24.04).
- fastfetch and phpactor are not installed on Ubuntu (fastfetch missing from repos; PHP LSP handled by cargo-installed `phpantom_lsp`).

First run:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/run.sh)"
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
