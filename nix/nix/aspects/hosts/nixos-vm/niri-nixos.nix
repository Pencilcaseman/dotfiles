{ inputs, ... }:
{
  den.aspects.nixos-vm-niri-nixos = {
    nixos = {
      imports = [
        inputs.niri.nixosModules.niri
      ];
    };
  };
}
