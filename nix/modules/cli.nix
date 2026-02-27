{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    # Nix Tools
    hydra-check
    nh
    nix-output-monitor
    nix-tree

    # Editors
    neovim
    fresh-editor

    # Core Tools
    bat
    btop
    fd
    flamegraph
    fzf
    just
    mdbook
    ripgrep
    ripgrep-all
    samply
    tokei
    tree
    unzip
    wget
    yazi
    zip
    zoxide

    # Git
    gh
    git
    gitoxide
    lazygit
    jujutsu

    # Media tools
    ffmpeg
    imagemagick

    # Misc
    topgrade
  ];
}
