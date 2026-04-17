{ den, inputs, ... }:
{
  den.aspects.nixos-vm = {
    includes = [
      den.aspects.nixpkgs-base
      den.aspects.nixos-vm-optimised-kernel
      den.aspects.nixos-vm-niri-nixos
      den.aspects.nixos-vm-niri-desktop
      den.aspects.nixos-vm-noctalia-shell
    ];

    nixos = { pkgs, ... }: {
      imports = [
        ../../../_hardware/nixos-vm.nix
      ];

      documentation = {
        dev.enable = true;
        man.generateCaches = true;
        nixos.includeAllModules = true;
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.networkmanager.enable = true;

      programs.niri.enable = true;

      services = {
        displayManager = {
          sddm = {
            enable = true;
            wayland.enable = true;
            theme = "sddm-astronaut-theme";
            extraPackages = with pkgs; [ sddm-astronaut ];
          };
        };

        openssh = {
          enable = true;
        };
      };

      hardware.graphics.enable = true;

      programs.zsh.enable = true;

      security.polkit.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        neovim
        git
        jujutsu
        wget
        kitty
        xwayland-satellite
        polkit_gnome
      ];
    };
  };
}
