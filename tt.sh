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
if [ "$DISTRO" == "ARCH" ]; then
  sudo pacman -S "$CORE_DEV" "noto-fonts-emoji"
elif [ "$DISTRO" == "DEB"]
  sudo apt update && sudo apt upgrade
  sudo apt install "$CORE_DEV" "fonts-powerline"
fi

# Oh my zsh from github
echo '[!] Downloading ohmyzsh. Do you want to read through source? [yn]'
wget 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'

while true; do
    read -p "[?] Do you want to read through the source code? [Yn]" yn
    case "$yn" in
        [Nn]* ) echo 'Ignoring safety concerns.. GG.'; break;;
        * ) less 'install.sh'; break;;
    esac
done

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
ln -sf "$LIBDIR/Nordic.colorscheme" "$HOME/.local/share/konsole/Nordi.colorscheme"
# Konsole config
ln -sf "$LIBDIR/konsolerc" "$HOME/.config/konsolerc"
# Konsole profile
ln -sf "$LIBDIR/kpro.profile" "$HOME/.local/share/konsole/kpro.profile"
# NVIM config
ln -sf "$LIBDIR/init.vim" "$HOME/.config/nvim/init.vim"
# tmux.conf
ln -sf "$LIBDIR/tmux.conf" "$HOME/.tmux.conf"
# zshrc
ln -sf "$LIBDIR/zshrc" "$HOME/.zshrc"

echo "[!] +++ Done. +++ Enjoy! +++"