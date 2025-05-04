use lib/fedora_cenv.nu provision_fedora_cenv

let cenv_name = $"fedora_cenv_(date now | format date "%Y%m%d%H%M%S")"
provision_fedora_cenv $cenv_name

