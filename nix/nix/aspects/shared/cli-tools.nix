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

        # Editor-related
        tree-sitter

        # Multiplexers
        tmux
        zellij

        # Core Tools
        bat
        btop
        bottom
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
        speedtest-cli
        topgrade

        # Manuals
        tealdeer
        rusty-man
        cppman
        man-pages
        man-pages-posix
      ] ++ lib.optionals pkgs.stdenv.isLinux [
        tailscale # Installed via .dmg on macOS
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
