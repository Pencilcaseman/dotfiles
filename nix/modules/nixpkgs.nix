{ inputs, config, pkgs, ... }: {
  nix.package = pkgs.lix;
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "root" "tobydavis" ];
    substituters = [ "https://cache.lix.systems" ];
    trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ] ++ (import ../overlays { inherit inputs; });
}
