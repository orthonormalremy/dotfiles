export def dnf_install_gum [] {
    # https://github.com/charmbracelet/gum?tab=readme-ov-file#installation
    '[charm]
    name=Charm
    baseurl=https://repo.charm.sh/yum/
    enabled=1
    gpgcheck=1
    gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
    sudo rpm --import https://repo.charm.sh/yum/gpg.key

    sudo dnf install gum
}