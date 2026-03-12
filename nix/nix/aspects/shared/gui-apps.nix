{
  den.aspects.gui-apps = {
    homeManager = { pkgs, lib, ... }: {
      home.packages = with pkgs; [
        firefox
        neovide
        rerun
      ] ++ lib.optionals pkgs.stdenv.isLinux [
        ghostty

        netbird
        netbird-ui

        libreoffice-fresh
      ];
    };
  };
}
