export def provision_fedora_cenv [name: string] {
    podman machine start out+err>| ignore
    (
        podman run -d
            --hostname $name
            --name $name
            fedora:latest sleep infinity
    )
    
    let dotfiles_repo_dir = git -C $env.FILE_PWD rev-parse --show-toplevel

    # this inits the `rdahlke` user (amoung other sysadmin/root-level setup things)
    podman cp $"($dotfiles_repo_dir)/scripts/sysadmin_setup_new_fedora_host.sh" $"($name):/tmp/"
    podman exec -it --user root $name /tmp/sysadmin_setup_new_fedora_host.sh

    let rdahlke_home_dir = podman exec --user rdahlke $name bash -c "echo ~"
    podman cp $dotfiles_repo_dir $"($name):($rdahlke_home_dir)"
}