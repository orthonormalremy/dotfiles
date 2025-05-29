def ensure_key_pair_id_rsa [] {
    (
        aws ec2 describe-key-pairs
            --filters "Name=key-name,Values=id_rsa"
            --output text
    ) | if ($in | str trim | is-empty) {
        (
            aws ec2 import-key-pair
                --key-name "id_rsa"
                --public-key-material fileb://~/.ssh/id_rsa.pub
        )
    }

}
