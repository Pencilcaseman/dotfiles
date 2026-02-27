# Dotfiles
My tool configuration and dotfiles.

## Prerequisites

### [Nix](https://nixos.org)

To make the most of the configuration, a NixPkgs/NixOS installation is required.
I recommend installing Nix via [Lix](https://lix.systems).

## Installation

Clone the repository into your `XDG_CONFIG_HOME` (`$HOME/.config` by default).

```
git clone https://github.com/Pencilcaseman/dotfiles.git ~/.config
```

Once the source code is available, run `setup.sh`.

### Nix

To configure Nix, run the following from the `nix` directory.

#### NixOS

```sh
cp /etc/nixos/hardware-configuration.nix ./hosts/<host>/
git add ./hosts/<host>/hardware-configuration.nix
sudo nixos-rebuild switch --flake .
```
