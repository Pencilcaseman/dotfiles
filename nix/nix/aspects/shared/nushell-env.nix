{
  den.aspects.nushell-env = {
    homeManager = { config, pkgs, ... }: {
      imports = [
        ../../_scripts/scripts.nix
      ];

      home.packages = with pkgs; [
        devenv
      ];

      programs = {
        direnv = {
          enable = true;
          enableNushellIntegration = true;
          nix-direnv.enable = true;
        };

        starship = {
          enable = true;
          enableNushellIntegration = true;
        };

        zoxide = {
          enable = true;
          enableNushellIntegration = true;
        };

        carapace = {
          enable = true;
          enableNushellIntegration = true;
        };

        nushell = {
          enable = true;

          configDir = "${config.xdg.configHome}/nushell";

          environmentVariables = config.home.sessionVariables;

          shellAliases = {
            cloc = "tokei";
            btmb = "btm --basic";
            fs   = "yazi";
            lg   = "lazygit";

            mvc = "mullvadforceconnect";
            mvd = "mullvadforcedisconnect";
            mvr = "mullvadreconnect";
          };

          extraEnv = ''
            $env.XDG_CONFIG_HOME            = "${config.xdg.configHome}"
            $env.NH_FLAKE                   = (["${config.xdg.configHome}", "nix"] | path join)
            $env.CARAPACE_BRIDGES           = "zsh,fish,bash,inshellisense"
            $env.PROMPT_INDICATOR_VI_NORMAL = ""
            $env.PROMPT_INDICATOR_VI_INSERT = ""

            if ($nu.os-info.name == "macos") {
              $env.MACOSX_DEPLOYMENT_TARGET = (sw_vers -productVersion)
            }

            $env.PATH = ([
              ($env.HOME | path join ".config" "bin")
              ($env.HOME | path join "opt" "bin")
              "/opt/homebrew/bin"
              "/usr/local/bin"
            ] ++ $env.PATH)

            if ("/usr/X11/bin" | path exists) {
              $env.PATH = (["/usr/X11/bin"] ++ $env.PATH)
            }

          # cargo token
          if (($env.CARGO_REGISTRY_TOKEN? | is-empty) and (($env.HOME | path join "opt" "cargo_token.txt") | path exists)) {
            $env.CARGO_REGISTRY_TOKEN = (open ($env.HOME | path join "opt" "cargo_token.txt") | str trim)
          }

          # 1Password SSH agent socket
          let op_sock = ($env.HOME | path join "Library" "Group Containers" "2BUA8C4S2C.com.1password" "t" "agent.sock")
          if ($op_sock | path exists) {
            $env.SSH_AUTH_SOCK = $op_sock
          }
          '';

          extraConfig = ''
            $env.config = {
              show_banner: false,

              edit_mode: "vi",

              cursor_shape: {
                vi_insert: line,
                vi_normal: block,
              },

              history: {
                file_format: sqlite,
                max_size: 1_000_000,
                sync_on_enter: true,
                isolation: true,
              },
            }

            let carapace_completer = {|spans|
              carapace $spans.0 nushell ...$spans | from json
            }

            $env.config = ($env.config | upsert completions.external {
              enable: true
              completer: $carapace_completer
            })

            def ssh [...args] {
              with-env { TERM: "xterm-256color" } { ^ssh ...$args }
            }

            def mullvadforcedisconnect [] {
              print "Disconnecting Mullvad VPN"
                ^mullvad lockdown-mode set off
                ^mullvad disconnect
                print $"You are now (ansi red_bold)UNSECURE(ansi reset)"
            }

            def mullvadforceconnect [] {
              print "Connecting Mullvad VPN"
                ^mullvad lockdown-mode set on
                ^mullvad connect
                print $"You are now (ansi green_bold)SECURE(ansi reset)"
            }

            def mullvadreconnect [] {
              let status = (^mullvad status | str trim)
                if ($status | str contains "Connected") {
                  ^mullvad reconnect
                    for _i in 1..3 {
                      print -n "."
                        sleep 500ms
                    }
                  print ""
                    print $"Mullvad (ansi green_bold)RECONNECTED(ansi reset)"
                } else {
                  mullvadforceconnect
                }
            }

            def gnz [] {
              with-env { NO_ZELLIJ_PLZ: "True" } { ^open -n "/Applications/Ghostty.app/" }
            }

            def nv [...args] {
              job spawn { ^neovide ...$args }
            }

            def nvm [] {
              ^nvim --clean
            }

            def mkcd [dir: string] {
              ^mkdir -p $dir
                cd $dir
            }

            def nproc [] {
              if ($nu.os-info.name == "macos") {
                ^sysctl -n hw.physicalcpu | str trim
              } else {
                ^nproc | str trim
              }
            }
          '';
        };

        # Required for better shell completions
        fish = {
          enable = true;
        };
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        OpenMP_ROOT = "${pkgs.llvmPackages.openmp.dev}";
      };
    };
  };
}
