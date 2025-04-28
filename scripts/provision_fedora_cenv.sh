#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$0")
CENV_NAME="fedora_cenv_$(date +%Y%m%d%H%M%S)"
echo "provisioning: ${CENV_NAME}"
echo ""

podman machine start &>/dev/null || true
podman run -d --name $CENV_NAME fedora:latest sleep infinity

podman cp "${SCRIPT_DIR}/sysadmin_setup_fedora_host.sh" $CENV_NAME:/tmp/sysadmin_setup_fedora_host.sh
podman exec -i --user root $CENV_NAME /tmp/sysadmin_setup_fedora_host.sh
