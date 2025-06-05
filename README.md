# dotfiles

## New Host Setup

### Linux (not NixOS)

#### 1. Install Nix

**1.1 Choose and Run the Appropriate Installer**

First, check your init system:

```bash
ps -p 1 -o comm=
```

**For systemd-based systems:**

Perform a multi-user installation with the [Determinate Nix installer](https://zero-to-nix.com/start/install/):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

```bash
exit # exit and open a new shell to refresh your environment
```

> **Why Determinate Systems?** Enables [flakes](https://zero-to-nix.com/concepts/flakes) and [unified CLI](https://zero-to-nix.com/concepts/nix/#unified-cli) by default, plus [additional features](https://github.com/DeterminateSystems/nix-installer/blob/main/README.md#features).

**For non-systemd systems:**

Perform a single-user installation with the [official installer](https://nixos.org/download/#nix-install-linux):

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
```

```bash
exit # exit and open a new shell to refresh your environment
```

> **Note:** Determinate Systems doesn't offer a single-user installer as of 2025-06-04.

**1.2 Verify Installation**

```bash
nix --version
```

**1.3 Enable Experimental Features**

Test if features are already enabled (should be automatic with Determinate Nix installer):

```bash
# test nix-command
nix config show

# test flakes
nix flake metadata --extra-experimental-features nix-command
```

If not enabled, add them manually:

```bash
mkdir -p ~/.config/nix
(set -C; echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf)
```

#### 2. Bootstrap System with Home Manager

Clone the dotfiles repository:

```bash
# I use my home directory (~) as the parent dir for the repo
nix-shell -p git --run "git -C $parent_dir clone https://github.com/orthonormalremy/dotfiles.git"
```

Install and activate [Home Manager](https://github.com/nix-community/home-manager) using the [flakes approach](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone):

```bash
# requires --impure because the flake.nix uses envionment variables
nix run home-manager/master -- switch --impure --flake $parent_dir/dotfiles/.config/home-manager
```

<details>
<summary>Remy, for your copy-paste convenience:</summary>

```bash
nix-shell -p git --run "git -C ~ clone https://github.com/orthonormalremy/dotfiles.git"
nix run home-manager/master -- switch --impure --flake ~/dotfiles/.config/home-manager
```

</details>
