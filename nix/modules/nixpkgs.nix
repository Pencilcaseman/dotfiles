{ inputs, config, pkgs, ... }: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ] ++ (import ../overlays { inherit inputs; });
}
