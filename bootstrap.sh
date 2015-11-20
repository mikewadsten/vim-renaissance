#!/usr/bin/env bash

# Variables
[ -z "$VUNDLE_URI" ] && VUNDLE_URI="https://github.com/gmarik/vundle.git"

# Basic setup tools
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" == "" ]; then
        ret=$?
    fi
    if [ "$ret" -eq 0 ]; then
        msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

program_exists() {
    local ret='0'
    type $1 >/dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [ ! "$ret" -eq '0' ]; then
        error "$2"
    fi
}

# Setup functions
lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
}

verbose_move() {
    echo "Moving $1 to $2"
    mv "$1" "$2"
}

do_backup() {
    if [ -e "$2" ] || [ -e "$3" ]; then
        today=`date +%Y%m%d_%s`
        for i in "$2" "$3"; do
            [ -e "$i" ] && verbose_move "$i" "$i.$today"
        done
        success "$1"
    fi
}

setup_vimplug() {
    if [ ! -d "$HOME/.nvim/autoload" ]; then
        mkdir -p "$HOME/.nvim"
        mkdir -p "$HOME/.vim/autoload"
        ln -sf "$HOME/.vim/autoload" "$HOME/.nvim/autoload"
    fi

    success "$1"
}

create_symlinks() {
    if [ -d "$HOME/personal/dotfiles/vim-renaissance" ]; then
        # Use new, more common location.
        endpath="$HOME/personal/dotfiles/vim-renaissance"
    else
        # Old outdated location. Left in for compatibility.
        endpath="$HOME/vim-renaissance"
    fi

    lnif "$endpath/vimrc"           "$HOME/.vimrc"
    lnif "$endpath/vimrc.bundles"   "$HOME/.vimrc.bundles"
    # Neovim!
    lnif "$HOME/.vimrc"             "$HOME/.nvimrc"

    success "$1"
}

setup_bundles() {
    system_shell="$SHELL"
    export SHELL='/bin/sh'
    vim -u "$HOME/.vimrc.bundles" +BundleInstall! +BundleClean +qall
    export SHELL="$system_shell"

    success "$1"
}

# Main
program_exists "vim"    "You need to install Vim or add it to your PATH."

do_backup "Your old vim stuff is backed up, to e.g. .vimrc.`date +%Y%m%d%S`" \
    "$HOME/.vimrc" \
    "$HOME/.vimrc.bundles"

create_symlinks "Setting up vim and nvim symlinks"

setup_vimplug   "Vim files should be set up now."

setup_bundles   "Installed/updated plugins using Vundle"

msg             "\nThanks for installing vim-renaissance"
msg             "© `date +%Y` Mike Wadsten. https://github.com/mikewadsten"
