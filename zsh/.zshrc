#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#

export EDITOR=emacs
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export GTK_USE_PORTAL=1
export GDK_DEBUG=portals
export QT_QPA_PLATFORMTHEME=xdgdesktopportal
export GO_PATH=$HOME/go/bin
export PATH=$PATH:~/.cargo/bin/:~/.local/bin:~/go/bin:~/.emacs.d/bin
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

ZSH_THEME=lambda

# -----------------------------------------------------
# oh-myzsh plugins
# -----------------------------------------------------
plugins=(
    git
    sudo
    web-search
    archlinux
    zsh-autosuggestions
    copyfile
    copybuffer
    dirhistory
    podman
    apache2-macports
    last-working-dir
    mysql-macports
    systemd
    git-extras
    taskwarrior
    docker
    urltools
    torrent
    vi-mode
    zsh-syntax-highlighting
    alias-finder
)

source $ZSH/oh-my-zsh.sh
#source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# -----------------------------------------------------
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
# -----------------------------------------------------
source $HOME/.zsh_fzf

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

alias findin='find $(pwd) -type f -exec grep -H "$1" {} \;'
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
#alias ls='eza -a --icons=always'
#alias ll='eza -al --icons=always'
#alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'
#alias v='$EDITOR'
#alias vim='$EDITOR'
alias wifi='nmtui'
alias updateansible='sh -c "$(curl -fsSL https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/run.sh)"'
alias copy='wl-copy'
alias sudo='sudo '
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias ssh-sparta='sshpass -f/home/gegebc/.sparta-pswd ssh portoalegre\\germano.bruscato@sparta.pucrs.br'
alias emacs='emacsclient --alternate-editor= --create-frame'
alias em='emacsclient -nw'
alias nano='vim -c smile'
alias vim='vim -c smile'
alias nvim='nvim -c smile'

md-to-org() {
    pandoc --from=markdown --to=org $1.md -o $1.org
}

md-to-org-rm() {
    pandoc --from=markdown --to=org $1.md -o $1.org && rm $1.md
}

lsperm() {
    ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) \
             *2^(8-i));if(k)printf("%0o ",k);print}'
}

ffgif() {
        ffmpeg -i $1.gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" $1.mp4
}

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

if [ -f ~/.zshrc_custom ]; then
    source ~/.zshrc_custom
fi
