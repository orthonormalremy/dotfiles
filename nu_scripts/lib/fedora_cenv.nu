const current_file = path self

export def provision_fedora_cenv [
    name: string
    --from-scratch
] {
    podman machine start out+err>| ignore
    let image_name = if $from_scratch { podman image pull fedora:latest; "fedora:latest" } else { "fedora_cenv:latest" }
    (
        podman run -d
            --hostname $name
            --name $name
            --pull never
            $image_name sleep infinity
    )
    
    let repo_root = git -C ($current_file | path dirname) rev-parse --show-toplevel
    let repo_name = $repo_root | path basename

    # this inits the `rdahlke` user (amoung other sysadmin/root-level setup things)
    podman cp $"($repo_root)/scripts/sysadmin_setup_new_fedora_host.sh" $"($name):/tmp/"
    podman exec -it --user root $name /tmp/sysadmin_setup_new_fedora_host.sh

    let rdahlke_home_dir = podman exec --user rdahlke $name bash -c "echo ~"
    podman cp $repo_root $"($name):($rdahlke_home_dir)/"
    podman exec -it --user rdahlke $name bash -c ([
        $"sudo chown --recursive rdahlke:rdahlke ($rdahlke_home_dir)/($repo_name)"
        $"($rdahlke_home_dir)/($repo_name)/scripts/rdahlke_setup_new_fedora_host.sh"
    ] | str join " && ")
}

export def rebuild_fedora_cenv_image [] {
    let cenv_name = $"tmp_fedora_cenv_to_commit_(date now | format date "%Y%m%d%H%M%S")"
    provision_fedora_cenv $cenv_name --from-scratch
    podman commit $cenv_name fedora_cenv
    podman stop $cenv_name
    podman rm $cenv_name
    podman image prune -f
}
