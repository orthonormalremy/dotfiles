export def provision_fedora_cenv [name: string] {
    podman machine start out+err>| ignore
    (
        podman run -d
            --hostname $name
            --name $name
            fedora:latest sleep infinity
    )
    
    let dotfiles_repo_path = git -C $env.FILE_PWD rev-parse --show-toplevel
    let dotfiles_repo_name = basename $dotfiles_repo_path

    # this inits the `rdahlke` user (amoung other sysadmin/root-level setup things)
    podman cp $"($dotfiles_repo_path)/scripts/sysadmin_setup_new_fedora_host.sh" $"($name):/tmp/"
    podman exec -it --user root $name /tmp/sysadmin_setup_new_fedora_host.sh

    let rdahlke_home_dir = podman exec --user rdahlke $name bash -c "echo ~"
    podman cp $dotfiles_repo_path $"($name):($rdahlke_home_dir)/"
    podman exec -it --user rdahlke $name $"($rdahlke_home_dir)/($dotfiles_repo_name)/scripts/rdahlke_setup_new_fedora_host.sh"
}
