{
  description = "Toby's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
    let specialArgs = { inherit inputs; };
  in
  {
    # macOS Configuration
    darwinConfigurations."Tobys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      inherit specialArgs;
      modules = [
          ./hosts/macbook-pro/configuration.nix
          ./modules/nixpkgs.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.tobydavis = import ./hosts/macbook-pro/home.nix;
          }
      ];
    };

    nixosConfigurations."tobys-nixos-vm" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      inherit specialArgs;
      modules = [
        ./hosts/nixos-desktop/configuration.nix
        ./modules/nixpkgs.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.tobydavis = import ./hosts/nixos-desktop/home.nix;
        }
      ];
    };
  };
}
