#!/bin/bash
set -e

# install system level packages
dnf upgrade -y --refresh
dnf group install -y development-tools || dnf group install -y "Development Tools"
dnf install -y \
    openssl \
    openssl-devel \
    shadow-utils

# init rdahlke user
id rdahlke &>/dev/null || useradd -m rdahlke
passwd -d rdahlke
echo "rdahlke ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rdahlke && chmod 440 /etc/sudoers.d/rdahlke
