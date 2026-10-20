#!/usr/bin/env bash
set -euo pipefail
cd "$HOME"

DOTFILES_DIR="$HOME/.dotfiles"

sudo pacman -S --needed git stow base-devel

if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles already exists. Skipping git clone..."
else
    echo "Dotfiles does not exist. Cloning repository..."
    git clone https://github.com/hamza-dev7/dotfiles.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"
git submodule update --init --recursive

sudo pacman -S --needed - < pkglist.txt

systemctl enable ly@tty2.service
sudo install -Db -S .bak -m644 ly/config.ini /etc/ly/config.ini

if ! command -v yay &>/dev/null; then
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

stow --restow --target="$HOME" applications env ghostty git niri noctalia rofi wallpapers yazi zed zsh zshrc
