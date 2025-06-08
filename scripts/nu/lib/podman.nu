export def wipe_podman_assets [] {
    podman machine start out+err>| ignore
    podman ps -a -q | lines | if ($in | is-not-empty) {
        podman stop ...$in
        podman rm ...$in
    }
    podman pod ls -q | lines | if ($in | is-not-empty) {
        podman pod rm -f ...$in
    }
    podman image ls -q | lines | if ($in | is-not-empty) {
        podman image rm -f ...$in
    }
    podman network ls -q | grep -v "podman" | lines | if ($in | is-not-empty) {
        podman network rm -f ...$in
    }
    podman volume ls -q | lines | if ($in | is-not-empty) {
        podman volume rm -f ...$in
    }
    podman secret ls -q | lines | if ($in | is-not-empty) {
        podman secret rm -f ...$in
    }
    podman system prune --external --force
    podman system prune --all --build --volumes --force
}
