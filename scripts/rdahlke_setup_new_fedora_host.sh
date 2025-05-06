#!/bin/bash
set -e

# setup git user and trust dotfiles repo
git config --global user.name "rdahlke"
git config --global user.email "orthonormalremy@gmail.com"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
(
    git config --global --get-all safe.directory
    git config --global --replace-all safe.directory "*"
    git -C $SCRIPT_DIR rev-parse --show-toplevel
    git config --global --unset-all safe.directory
) | sort -u | while read -r repo; do
    git config --global --add safe.directory "$repo"
done
DOTFILES_REPO_DIR="$(git -C $SCRIPT_DIR rev-parse --show-toplevel)"

# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# install nushell
cargo install nu --locked
nu "$DOTFILES_REPO_DIR/nu_scripts/rdahlke_setup_new_fedora_host.nu"
