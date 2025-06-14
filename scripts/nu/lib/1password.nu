use crypto_utils.nu aes_decrypt_salted

export def dnf_install_1password [] {
    # https://developer.1password.com/docs/cli/get-started/
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install -y 1password-cli
}

export def add_primary_account [] {
    print "Enter https://codeberg.org/orthonormalremy/secrets password: "
    let op_secret_key_encrypted = (
        ^curl -s -u orthonormalremy https://codeberg.org/orthonormalremy/secrets/raw/branch/main/OP_SECRET_KEY.enc
    ) | into string
    let password = input --suppress-output "Enter password to decrypt OP_SECRET_KEY: "
    print ""
    let op_secret_key = $op_secret_key_encrypted | aes_decrypt_salted $password
    (
        OP_SECRET_KEY=$op_secret_key
            op account add
                --address "my.1password.com"
                --email "orthonormalremy@gmail.com"
    )
}
