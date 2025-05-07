#!/bin/bash
set -e

###################
# Helper Functions
###################

function _trust_parent_git_repo () {
    # Trust git repo containing the given subdirectory
    # Arguments:
    #   $1 - A subdirectory path within the git repo to be trusted
    trusted_repo_stash=$(mktemp --suffix trusted_repo_stash)
    git config --global --get-all safe.directory > "$trusted_repo_stash"
    git config --global --replace-all safe.directory "*"
    git -C "$1" rev-parse --show-toplevel >> "$trusted_repo_stash" || true
    git config --global --unset-all safe.directory
    sort -u "$trusted_repo_stash" | while IFS= read -r repo; do
        git config --global --add safe.directory "$repo"
    done
    # git -C "$1" rev-parse --show-toplevel

    echo "EXIT"
}


echo "HIT_1a"
##############
# Main Script
##############

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# setup git user and trust dotfiles repo
git config --global user.name "rdahlke"
git config --global user.email "orthonormalremy@gmail.com"
_trust_parent_git_repo $SCRIPT_DIR
DOTFILES_REPO_DIR="$(git -C $SCRIPT_DIR rev-parse --show-toplevel)"


echo "HIT_1b"
sleep 2
# exit 1

# # install rustup
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# source "$HOME/.cargo/env"

# # install nushell and continue new fedora host setup from nushell script
# cargo install nu --locked
# nu "$DOTFILES_REPO_DIR/nu_scripts/rdahlke_setup_new_fedora_host.nu"
