{ inputs, ... }:
{
  den.aspects.nixos-vm-niri-nixos = {
    nixos = {
      imports = [
        inputs.niri.nixosModules.niri
      ];
    };

    homeManager = {
      imports = [
        inputs.niri.homeModules.niri
      ];
    };
  };
}
