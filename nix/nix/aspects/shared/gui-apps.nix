{ den, ... }:
{
  den.aspects.gui-apps = {
    includes = [
      den.aspects.fonts
    ];

    homeManager = { pkgs, lib, ... }: {
      home.packages = with pkgs; [
        anki
        audacity
        firefox
        neovide
        qbittorrent
        rerun
        signal-desktop
        vesktop
      ] ++ lib.optionals pkgs.stdenv.isLinux [
        ghostty

        libreoffice-fresh

        obs-studio

        gnome-calculator
        gnome-notes
        gnome-chess
        gnome-sudoku

        # Desktop utilities
        nautilus
        pavucontrol
        networkmanagerapplet
        grim
        slurp
        cliphist
        brightnessctl
      ];
    };
  };
}
