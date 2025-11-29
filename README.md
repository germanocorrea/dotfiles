# germanocorrea/dotfiles

My personal dotfiles. Public because at the first setup after OS installation I might not have SSH configured.

First run:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/run.sh)"
```

After first run, an alias is configured for updating everything:
```sh
updateansible
```


## How run.sh works
- Checks if Ansible and it's pre-requisits are installed for applying the playbook.
  - For Arch/CachyOS, it installs through the distro's own repositories, and installs kewlfft.aur
  - For Ubuntu, it adds the necessary PPA for ansible
- Check if there is a dotfiles direcotry already. If there is, it commits everything that is uncommited and pushes everything unpushed.
- Executes the playbook fetching it from github

### Why Arch, Cachy and Ubuntu?

I use CachyOS on my main computer, Arch on a homelab server, and Ubuntu on my work computer. This interoperability is important.

### Why commit and push everything?

I built this so that some configurations that I change "on the fly" via GUIs (like the COSMIC DE) or that other software changes automatically (like a PATH export) reflect automatically in the dotfiles repo, so I thought this is easier.

### Why execute the playbook fetching from github?

The idea is that the `run.sh` script tries to be idempotent. This means that running it multiple times should reflect on the same state, even if nothing is yet configured (not even Ansible) or everything is already configured. It is suposed to be an all-around script for this.

## Installed packages

