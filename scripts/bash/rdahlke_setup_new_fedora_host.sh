#!/usr/bin/env bash
set -e

prefer_cargo_install=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --prefer-cargo-install)
            prefer_cargo_install=true
            shift
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            # Handle positional arguments here if needed
            shift
            ;;
    esac
done

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# setup git user and trust dotfiles repo
git config --global user.name "rdahlke"
git config --global user.email "orthonormalremy@gmail.com"
git config --global --replace-all safe.directory "*"
REPO_ROOT="$(git -C $SCRIPT_DIR rev-parse --show-toplevel)"

# setup symlinks
# ln -s "$REPO_ROOT/.config" ~/.config
# TBD: maybe only handle rust up, cargo, and nu config here (and do rest from nu)

# install nushell (and rustup if needed)
if [ "$prefer_cargo_install" = true ]; then
    # install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"

    # when using cargo, default core nu plugins must be installed separately
    # https://www.nushell.sh/book/installation.html#build-from-crates-io-using-cargo
    cargo install nu --locked
    nu "$REPO_ROOT/nu_scripts/cargo_install_core_nu_plugins.nu"
else
    bash "$REPO_ROOT/scripts/dnf_install_nushell.sh"
fi

# continue new fedora host setup from nushell script
if [ "$prefer_cargo_install" = true ]; then
    nu "$REPO_ROOT/nu_scripts/rdahlke_setup_new_fedora_host.nu" --prefer-cargo-install
else
    nu "$REPO_ROOT/nu_scripts/rdahlke_setup_new_fedora_host.nu"
fi
