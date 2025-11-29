# germanocorrea/dotfiles

My personal dotfiles for the machines and distros I use. Public because at the first setup after OS installation I might not have SSH configured.

First run:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/run.sh)"
```

After first run, an alias is configured for updating everything:
```sh
updateansible
```

## How run.sh works
- Checks if Ansible and it's prerequisites are installed for applying the playbook.
  - For Arch/CachyOS, it installs through the distro's own repositories, and installs kewlfft.aur
  - For Ubuntu, it adds the necessary PPA for ansible
- Check if there is a dotfiles directory already. If there is, it commits everything that is uncommited and pushes everything unpushed.
- Executes the playbook fetching it from github
