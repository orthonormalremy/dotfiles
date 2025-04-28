#!/bin/bash
set -e

podman machine start &>/dev/null || true

if [ "$(podman ps -a -q)" != "" ]; then
    podman stop $(podman ps -a -q)
    podman rm $(podman ps -a -q)
fi

if [ "$(podman pod ls -q)" != "" ]; then
    podman pod rm -f $(podman pod ls -q)
fi

if [ "$(podman image ls -q)" != "" ]; then
    podman image rm -f $(podman image ls -q)
fi

if [ "$(podman network ls -q | grep -v "podman")" != "" ]; then
    podman network rm -f $(podman network ls -q | grep -v "podman")
fi

if [ "$(podman volume ls -q)" != "" ]; then
    podman volume rm -f $(podman volume ls -q)
fi

if [ "$(podman secret ls -q)" != "" ]; then
    podman secret rm -f $(podman secret ls -q)
fi

podman system prune --external --force
podman system prune --all --build --volumes --force

echo "success"
