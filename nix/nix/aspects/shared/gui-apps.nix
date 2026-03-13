{
  den.aspects.gui-apps = {
    homeManager = { pkgs, lib, ... }: {
      home.packages = with pkgs; [
        firefox
        neovide
        rerun
        audacity
        signal-desktop
        vesktop
      ] ++ lib.optionals pkgs.stdenv.isLinux [
        ghostty

        netbird
        netbird-ui

        libreoffice-fresh

        obs-studio

        gnome-calculator
        gnome-notes
        gnome-chess
        gnome-sudoku
      ];
    };
  };
}
