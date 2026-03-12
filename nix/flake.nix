{
  description = "Toby's Nix Configuration";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./nix);

  inputs = {
    # Den ecosystem
    den.url = "github:vic/den";

    flake-aspects.url = "github:vic/flake-aspects";

    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };

    import-tree.url = "github:vic/import-tree";

    nixpkgs-lib.follows = "nixpkgs";

    # Kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
}
