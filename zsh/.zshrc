#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#
# zmodload zsh/zprof # init zsh startup performance monitoring
export EDITOR=emacsclient
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export GTK_USE_PORTAL=1
export GDK_DEBUG=portals
export QT_QPA_PLATFORMTHEME=xdgdesktopportal
export GO_PATH=$HOME/go/bin
export PATH=$PATH:~/.cargo/bin/:~/.local/bin:~/go/bin:~/.emacs.d/bin:~/.config/emacs/bin

DISABLE_AUTO_UPDATE="true"
ZSH_THEME=lambda

# -----------------------------------------------------
# Detect current distro (arch | cachyos | ubuntu | ...)
# Used to load distro-specific plugins and configs below.
# -----------------------------------------------------
if [[ -r /etc/os-release ]]; then
    . /etc/os-release
fi
DISTRO="${ID:-unknown}"

# -----------------------------------------------------
# oh-myzsh plugins
# -----------------------------------------------------
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:zsh-autosuggestions' lazy yes
zstyle ':omz:plugins:zsh-syntax-highlighting' lazy yes
plugins=(
    git
    sudo
    web-search
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
    docker
    urltools
    torrent
    zsh-syntax-highlighting
    alias-finder
    nvm
)

# Distro-specific plugins (must be added before oh-my-zsh is sourced)
case "$DISTRO" in
    arch|cachyos) plugins+=(archlinux) ;;
    # omz's fzf plugin works with Ubuntu's older fzf (no vendored bindings needed)
    ubuntu) plugins+=(fzf common-aliases) ;;
esac

source $ZSH/oh-my-zsh.sh
#source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# -----------------------------------------------------
# Distro-specific configuration (fzf, aliases, etc.)
# See .zshrc_arch / .zshrc_ubuntu in the dotfiles repo.
# -----------------------------------------------------
if [[ -r "$HOME/.zshrc_${DISTRO}" ]]; then
    source "$HOME/.zshrc_${DISTRO}"
elif [[ -r "$HOME/dotfiles/zsh/.zshrc_${DISTRO}" ]]; then
    # Fallback: distro file exists in the repo but isn't stowed yet
    source "$HOME/dotfiles/zsh/.zshrc_${DISTRO}"
fi

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
alias updateansible='bash -c "$(curl -fsSL https://raw.githubusercontent.com/germanocorrea/dotfiles/refs/heads/main/run.sh)"'
alias copy='wl-copy'
alias sudo='sudo '
alias ssh-sparta='sshpass -f /home/gegebc/.sparta-pswd ssh portoalegre\\germano.bruscato@sparta.pucrs.br'
alias emacs='emacsclient --alternate-editor= --create-frame'
alias em='emacsclient -nw'
alias nano='vim -c smile'
alias vim='vim -c smile'
alias nvim='nvim -c smile'
alias icat="kitty +kitten icat"
alias which="which -a"

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

# manual lazy loading of nvm
# nvm() {
#     unfunction nvm
#     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#     [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#     nvm "$@"
# }

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

if [ -f ~/.zshrc_custom ]; then
    source ~/.zshrc_custom
fi
# zprof # compile performance of zsh startup

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
