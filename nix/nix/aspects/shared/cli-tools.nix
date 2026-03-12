{
  den.aspects.cli-tools = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        # Nix Tools
        hydra-check
        nh
        nix-output-monitor
        nix-tree

        # Editors
        vim
        neovim
        fresh-editor

        # Multiplexers
        tmux
        zellij

        # Core Tools
        bat
        btop
        dust
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
        git-lfs
        gitoxide
        lazygit
        jujutsu

        # Media tools
        ffmpeg
        imagemagick

        # Misc
        topgrade
      ];

      programs = {
        man = {
          enable = true;
          package = pkgs.man;
          generateCaches = true;
        };
      };
    };
  };
}
