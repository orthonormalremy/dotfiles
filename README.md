# dotfiles

## New Host Setup

### Linux (not NixOS)

#### 1. Install Nix

Check your init system:

```bash
ps -p 1 -o comm=
```

If your system uses systemd, install with the [Determinate Nix installer](https://zero-to-nix.com/start/install/):
* Advantages: [flakes](https://zero-to-nix.com/concepts/flakes) and [unified CLI](https://zero-to-nix.com/concepts/nix/#unified-cli) enabled by default; [other features](https://github.com/DeterminateSystems/nix-installer/blob/main/README.md#features)


```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# `exit` and open a new shell to refresh your environment
```

If your system does not use systemd, perform a [single-user installation](https://nixos.org/download/#nix-install-linux):

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

# `exit` and open a new shell to refresh your environment
```

Confirm nix is installed:

```bash
nix --version
```

**1.1 Enable `flakes` and `nix-command`**

Check if these features are already enabled (should be the case if you used the Determinate Systems installer):

```bash
# test if `nix-command` is enabled
# if not, you will get an error like "experimental Nix feature 'nix-command' is disabled"
nix config show

# test if `flakes` are enabled
# if not, you will get an error like: "experimental feature 'flakes' is disabled"
nix flake metadata --extra-experimental-features nix-command
```

Enable these features if not already enabled:

```bash
mkdir -p ~/.config/nix
(set -C; echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf)
```

#### 2. Boostrap System Using [Home Manager](https://github.com/nix-community/home-manager)

Clone this dotfiles repository which includes the home-manager config:

```bash
# I use my home directory (`~`) as the parent dir for the dotfiles repo
nix-shell -p git --run "git -C $parent_dir_for_repo clone https://github.com/orthonormalremy/dotfiles.git"
```

Install and activate home-manager using the flakes approach ([link](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone)):

```bash
nix run home-manager/master -- init --switch $parent_dir_for_repo/dotfiles/.config/home-manager
```

<details>
<summary>Remy, for your copy-paste convenience:</summary>

```bash
nix-shell -p git --run "git -C ~ clone https://github.com/orthonormalremy/dotfiles.git"
nix run home-manager/master -- init --switch ~/dotfiles/.config/home-manager
```

</details>

