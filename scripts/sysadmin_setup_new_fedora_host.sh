#!/bin/bash
set -e

id rdahlke &>/dev/null || useradd -m rdahlke
passwd -d rdahlke
echo "rdahlke ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rdahlke && chmod 440 /etc/sudoers.d/rdahlke

dnf upgrade -y --refresh
dnf group install -y development-tools
dnf install -y openssl-devel
