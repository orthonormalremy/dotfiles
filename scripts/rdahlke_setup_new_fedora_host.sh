#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# setup git user and trust dotfiles repo
git config --global user.name "rdahlke"
git config --global user.email "orthonormalremy@gmail.com"
git config --global --replace-all safe.directory "*"
DOTFILES_REPO_DIR="$(git -C $SCRIPT_DIR rev-parse --show-toplevel)"

# setup symlinks
ln -s "$DOTFILES_REPO_DIR/.config" ~/.config

# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# install nushell and continue new fedora host setup from nushell script
cargo install nu --locked
nu "$DOTFILES_REPO_DIR/nu_scripts/rdahlke_setup_new_fedora_host.nu"
