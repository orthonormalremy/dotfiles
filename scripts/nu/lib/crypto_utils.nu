export def aes_encrypt_salted [password: string]: string -> string {
    (
        ^bash -c $'echo "($in)" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:"($password)"'
    ) | into string
}

export def aes_decrypt_salted [password: string]: string -> string {
    (
        ^bash -c $'echo "($in)" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"($password)"'
    ) | into string
}
