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
        _7zip-zstd
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
        typos
        unzip
        wget
        yazi
        zip
        zoxide

        # Git (more configuration below)
        gh
        gitoxide
        lazygit
        jujutsu

        # Media tools
        ffmpeg
        imagemagick
        mpv
        poppler-utils

        # Misc
        aria2
        awscli2
        motrix-next
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
        jujutsu = {
          enable = true;

          settings = {
            user = {
              name = "Toby Davis";
              email = "toby@tobydavis.dev";
            };

            signing = {
              behavior = "own";
              backend = "ssh";
              key = "~/.ssh/git_signing_key.pub";
              backends.ssh.program =
                if pkgs.stdenv.isDarwin
                then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
                else "${pkgs._1password-gui}/bin/op-ssh-sign";
            };

            git.sign-on-push = true;

            ui.default-command = "log";

            templates.log_node = ''
              if(self && !current_working_copy && !immutable && !conflict && in_branch(self),
                "◇",
                builtin_log_node
              )
            '';

            template-aliases."in_branch(commit)" = ''commit.contained_in("immutable_heads()..bookmarks()")'';
          };
        };

        git = {
          enable = true;

          package = pkgs.gitFull;

          lfs.enable = true;

          maintenance.enable = true;

          settings = {
            init = {
              defaultBranch = "main";
            };

            url = {
              "https://github.com/" = {
                insteadOf = [
                  "gh:"
                  "github:"
                ];
              };
            };
          };
        };

        difftastic = {
          enable = true;
          git.enable = true;
          jujutsu.enable = true;
        };

        man = {
          enable = true;
          package = pkgs.man;
          generateCaches = true;
        };
      };
    };
  };
}
