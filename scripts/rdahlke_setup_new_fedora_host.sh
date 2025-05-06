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

# install nushell and default plugins (https://www.nushell.sh/book/plugins.html#core-plugins)
cargo install nu --locked
nu -c "$(cat <<'EOF'
[
    nu_plugin_inc
    nu_plugin_polars
    nu_plugin_gstat
    nu_plugin_formats
    nu_plugin_query
] | each { cargo install $in --locked } | ignore
EOF
)"
