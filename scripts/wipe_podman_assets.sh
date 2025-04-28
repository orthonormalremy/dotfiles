#!/bin/bash
set -e

podman stop $(podman ps -a -q) && podman rm $(podman ps -a -q)
podman rmi $(podman images -q) --force
podman system prune -a --volumes --force
