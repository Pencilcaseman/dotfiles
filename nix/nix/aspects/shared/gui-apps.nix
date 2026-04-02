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
        qbittorrent
      ] ++ lib.optionals pkgs.stdenv.isLinux [
        ghostty

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
