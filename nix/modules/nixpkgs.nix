{ inputs, config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ] ++ (import ../overlays { inherit inputs; });
}
