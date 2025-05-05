#!/bin/bash
set -e

# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# install nushell and default plugins (https://www.nushell.sh/book/plugins.html#core-plugins)
cargo install nu --locked
nu -c "$(cat <<'EOF'
[ nu_plugin_inc
  nu_plugin_polars
  nu_plugin_gstat
  nu_plugin_formats
  nu_plugin_query
] | each { cargo install $in --locked } | ignore
EOF
)"

