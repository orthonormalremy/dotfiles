# ensure nushell default plugins are installed (not included in the cargo install)
# https://www.nushell.sh/book/plugins.html#core-plugins
[
    nu_plugin_inc
    nu_plugin_polars
    nu_plugin_gstat
    nu_plugin_formats
    nu_plugin_query
] | each { cargo install $in --locked } | ignore


# install packages
sudo dnf install -y podman

use lib/1password.nu dnf_install_1password
dnf_install_1password


# ensure secrets
if not ([ ~/.ssh/id_rsa, ~/.ssh/id_rsa.pub ] | path exists | all {}) {
    mkdir ~/.ssh
    
    use lib/1password.nu add_primary_account
    add_primary_account

    # sign in to 1password using bash (https://developer.1password.com/docs/cli/sign-in-manually)
    let  1password_env = bash -c ([
        'eval $(op signin) >/dev/null'
        'python -c "import json; import os; print(json.dumps(dict(os.environ)))"' # use python to get env as json
    ] | str join " && ") | from json | select ...($in | columns | where ($it | str starts-with "OP_" ))

    with-env $1password_env {
        print "saving down id_rsa and id_rsa.pub to ~/.ssh"
        op read op://Shared/id_rsa/private_key out> ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        op read op://Shared/id_rsa/public_key out> ~/.ssh/id_rsa.pub
        chmod 644 ~/.ssh/id_rsa.pub
    }
}
