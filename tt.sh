#!/bin/bash

echo 'Attempting to setup a dev environment and place all dotfiles.'
# Determine Distro, default is Arch Linux.
# This determines packet manager commands etc.
DISTRO="ARCH"
if `uname -a | grep -q 'Debian'`; then
  DISTRO="DEB"
fi

# Absolute core dev packages.
CORE_DEV="konsole neovim zsh tmux powerline"

echo '[!] Installing packages. Requires sudo privs.'
# Install basic toolkit
if [[ "$DISTRO" == "ARCH" ]]; then
  sudo pacman -Syu
  sudo pacman -S "$CORE_DEV" "noto-fonts-emoji"
elif [[ "$DISTRO" == "DEB" ]]; then
  sudo apt update && sudo apt upgrade
  sudo apt install "$CORE_DEV" "fonts-powerline"
fi

# Oh my zsh from github

OMZPATH='/tmp/ohmyzsh.sh'
echo '[!] Downloading ohmyzsh. Do you want to read through source? [yn]'
wget -O "$OMZPATH" 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'

while true; do
    read -p "[?] Do you want to read through the source code? [Yn]" yn
    case "$yn" in
        [Nn]* ) echo 'Ignoring safety concerns.. GG.'; break;;
        * ) less "$OMZPATH"; break;;
    esac
done
bash "$OMZPATH"

# Tmux Plugin manager from github
echo '[!] Installing Tmux Plugin Manager (TPM).'
echo '[+] Source code available at https://github.com/tmux-plugins/tpm.'
git clone 'https://github.com/tmux-plugins/tpm' '~/.tmux/plugins/tpm'


# Linking dotfiles.
echo '[!] Linking dotfiles.'
LIBDIR="$PWD/lib/"

# Gitconfig
ln -sf "$LIBDIR/gitconfig" "$HOME/.gitconfig"
# Konsole colorscheme
KONSOLE_COLORSCHEME_DIR="$HOME/.local/share/konsole"
mkdir -p $KONSOLE_COLORSCHEME_DIR
ln -sf "$LIBDIR/Nordic.colorscheme" "$KONSOLE_COLORSCHEME_DIR/Nordic.colorscheme"
# Konsole config
KONSOLE_RC_DIR="$HOME/.config"
mkdir -p "$KONSOLE_RC_DIR"
ln -sf "$LIBDIR/konsolerc" "$KONSOLE_RC_DIR/konsolerc"
# Konsole profile
KONSOLE_PROFILE_DIR="$KONSOLE_COLORSCHEME_DIR"
mkdir -p "$KONSOLE_PROFILE_DIR"
ln -sf "$LIBDIR/kpro.profile" "$KONSOLE_PROFILE_DIR/kpro.profile"
# NVIM config
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"
ln -sf "$LIBDIR/init.vim" "$NVIM_CONFIG_DIR/init.vim"
# tmux.conf
ln -sf "$LIBDIR/tmux.conf" "$HOME/.tmux.conf"
# zshrc
ln -sf "$LIBDIR/zshrc" "$HOME/.zshrc"

echo "[!] +++ Done. +++ Enjoy! +++"