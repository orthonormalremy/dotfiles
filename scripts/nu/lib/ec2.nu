export def ensure_key_pair_id_rsa [] {
    (
        ^aws ec2 describe-key-pairs
            --filters "Name=key-name,Values=id_rsa"
            --output text
    ) | if ($in | str trim | is-empty) {
        (
            ^aws ec2 import-key-pair
                --key-name "id_rsa"
                --public-key-material fileb://~/.ssh/id_rsa.pub
        )
    }

}

export def ensure_primary_firewall [] {
    (
        ^aws ec2 describe-security-groups
            --filters "Name=group-name,Values=primary-firewall"
            --output text
    ) | if ($in | str trim | is-empty) {
        let default_vpc_id = (
            ^aws ec2 describe-vpcs
                --filters "Name=isDefault,Values=true"
                --query "Vpcs[0].VpcId"
                --output text
        )
        (
            ^aws ec2 create-security-group
                --group-name "primary-firewall"
                --description $'primary-firewall created (date now | format date "%+")'
                --vpc-id $default_vpc_id
        )
    }
}

export def primary_firewall_inbound_allowlist_add [] {
    
}