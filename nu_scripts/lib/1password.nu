export const PRIMARY_ACCOUNT_USER_ID = "3WERKMN4HRCTLCLO6ZD7HMI2RE"

export def dnf_install_1password [] {
    # https://developer.1password.com/docs/cli/get-started/
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install -y 1password-cli
}

export def add_primary_account [] {
    (
        OP_SECRET_KEY="A3-5NNZGM-77GAXA-4YBVE-WD7WB-NC8GJ-E46XR"
            op account add
                --address my.1password.com
                --email orthonormalremy@gmail.com
                --signin
    )
}
