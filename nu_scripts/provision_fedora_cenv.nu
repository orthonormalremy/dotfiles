use lib/fedora_cenv.nu provision_fedora_cenv

let cenv_name = $"fedora_cenv_(date now | format date "%Y%m%d%H%M%S")"
provision_fedora_cenv $cenv_name

print $cenv_name
if (((input "enter cenv? [y/N] ") | str downcase) == 'y') {
    podman exec -it --user rdahlke $cenv_name bash -c "cd ~ && bash"

    if (((input $"delete cenv: ($cenv_name)? [y/N] ") | str downcase) == 'y') {
        podman stop $cenv_name
        podman rm $cenv_name
    }
}
