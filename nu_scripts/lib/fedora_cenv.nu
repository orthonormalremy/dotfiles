export def new_fedora_cenv [] {
    podman machine start out+err>| ignore
    (
        podman run -d
            --hostname "lol"
            --name "lol"
            fedora:latest sleep infinity
    )
}