const current_file = path self
let repo_root = git -C ($current_file | path dirname) rev-parse --show-toplevel

# install packages
sudo dnf install -y podman

use lib/1password.nu dnf_install_1password
dnf_install_1password


# ensure secrets
if not (~/.ssh/id_rsa | path exists) {
    print "user does not have secrets; attempting to fetch them"
    mkdir ~/.ssh
    
    use lib/1password.nu add_primary_account
    add_primary_account

    # sign in to 1password (https://developer.1password.com/docs/cli/sign-in-manually)
    # nu does not support `eval` so using bash (https://www.nushell.sh/book/thinking_in_nu.html#think-of-nushell-as-a-compiled-language)
    let 1password_env = bash -c ([
        'eval $(op signin) >/dev/null'
        'python -c "import json; import os; print(json.dumps(dict(os.environ)))"' # use python to get env as json
    ] | str join " && ") | from json | select ...($in | columns | where ($it | str starts-with "OP_" ))

    with-env $1password_env {
        print "saving down id_rsa ~/.ssh"
        op read op://Shared/id_rsa/private_key out> ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keygen -y -f ~/.ssh/id_rsa out> ~/.ssh/id_rsa.pub
    }
} else {
    print "user already has secrets"
}

git -C $repo_root remote set-url origin (
    if (~/.ssh/id_rsa | path exists) { "git@github.com:orthonormalremy/dotfiles.git" } else { "https://github.com/orthonormalremy/dotfiles.git" }
)
git -C $repo_root remote -v
