{ pkgs, modulesPath, ... }:
{
  nix.package = pkgs.lix;
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tobys-nixos-vm";
  networking.networkmanager.enable = true;

  programs.niri.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  hardware.graphics.enable = true;

  users.users.tobydavis = {
    isNormalUser = true;
    description = "Toby Davis";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    kitty
    waybar
    mako
    xwayland-satellite
  ];

  system.stateVersion = "26.05";
}
