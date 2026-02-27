{ pkgs, ... }: {
  home.packages = with pkgs; [
    firefox
    neovide
    rerun
    zellij
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ghostty
  ];
}
