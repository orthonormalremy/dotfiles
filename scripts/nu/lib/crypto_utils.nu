export def aes_encrypt_salted []: string -> string {
    let password = input --suppress-output
    (
        bash -c $'echo "($in)" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:($password)'
    ) | into string
}

export def aes_decrypt_salted []: string -> string {
    let password = input --suppress-output
    (
        bash -c $'echo "($in)" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:($password)'
    ) | into string
}
