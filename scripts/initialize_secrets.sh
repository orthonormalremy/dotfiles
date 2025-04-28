#!/bin/bash
set -e

dnf_install_1password() {
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf check-update -y 1password-cli && sudo dnf install -y 1password-cli
}

install_1password() {
# https://developer.1password.com/docs/cli/get-started/
    if command -v dnf &> /dev/null; then
        dnf_install_1password
    else
        echo "dnf not found; please install 1Password CLI manually"
        exit 1
    fi
}

# ensure 1password
if command -v op &> /dev/null; then
    op --version
else
    echo "1Password CLI not found; installing now"
    install_1password
    op --version
fi

# signin to 1password
eval $( \
    OP_SECRET_KEY="A3-5NNZGM-77GAXA-4YBVE-WD7WB-NC8GJ-E46XR" \
        op account add \
            --address my.1password.com \
            --email orthonormalremy@gmail.com \
            --signin \
)

# save down ssh key pair from 1password
mkdir -p ~/.ssh
if ! [ -f ~/.ssh/id_rsa ] && ! [ -f ~/.ssh/id_rsa.pub ]; then
    echo "saving down id_rsa and id_rsa.pub to ~/.ssh"
    op read op://Shared/id_rsa/private_key > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
    op read op://Shared/id_rsa/public_key > ~/.ssh/id_rsa.pub && chmod 644 ~/.ssh/id_rsa.pub
else
    echo "one or both file(s) already exists: ~/.ssh/id_rsa ~/.ssh/id_rsa.pub"
    echo "skipping ssh key pair save down"
    exit 1
fi
