#!/bin/bash
set -e

useradd -m rdahlke
passwd -d rdahlke # no password
echo "rdahlke ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/rdahlke && chmod 440 /etc/sudoers.d/rdahlke

dnf install -y git
