export def wipe_podman_assets [] {
    podman machine start out+err>| ignore
    podman ps -a -q | if $in != "" {
        podman stop $in
        podman rm $in
    }
    podman pod ls -q | if $in != "" {
        podman pod rm -f $in
    }
    podman image ls -q | if $in != "" {
        podman image rm -f $in
    }
    podman network ls -q | grep -v "podman" | if $in != "" {
        podman network rm -f $in
    }
    podman volume ls -q | if $in != "" {
        podman volume rm -f $in
    }
    podman secret ls -q | if $in != "" {
        podman secret rm -f $in
    }
    podman system prune --external --force
    podman system prune --all --build --volumes --force
}
