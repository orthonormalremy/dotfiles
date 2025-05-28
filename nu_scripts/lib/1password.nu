export def dnf_install_1password [] {
    # https://developer.1password.com/docs/cli/get-started/
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install -y 1password-cli
}

export def add_primary_account [] {
    let encrypted_op_secret_key = "U2FsdGVkX18srrnKii9DKH/AdSuOikIVKNyzwjTv+yQh8MVxV6MiTi9Y/r3pH6lgB/tj+7exIxcMbCxM6VqTzg=="
    let decrypt_password = input --suppress-output
    # unable to get `$encrypted_op_secret_key | ^openssl ...` to work in nu so using bash -c
    let op_secret_key = bash -c $'echo "($encrypted_op_secret_key)" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:($decrypt_password)'
    (
        OP_SECRET_KEY=$op_secret_key
            op account add
                --address "my.1password.com"
                --email "orthonormalremy@gmail.com"
    )
}
