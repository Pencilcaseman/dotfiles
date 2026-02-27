{ config, pkgs, ... }:

{
  imports = [
    ../../modules/apps.nix
    ../../modules/cli.nix
    ../../modules/dev.nix
    ../../modules/shell/shell.nix
  ];

  home.username = "tobydavis";
  home.homeDirectory = "/home/tobydavis";

  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
          layout "gb"
        }
      }
      touchpad {
        tap
        dwt
      }
    }

    output "Virtual-1" {
      mode "1920x1080"
      scale 1.0
    }

    layout {
      gaps 16
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 4
        active-color "#7fc8ff"
        inactive-color "#505050"
      }
    }

    binds {
      Mod+Shift+E { quit; }
      Mod+Q { close-window; }
      Mod+Return { spawn "kitty"; }
      Mod+D { spawn "fuzzel"; }

      Mod+Left  { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up    { focus-window-or-workspace-up; }
      Mod+Down  { focus-window-or-workspace-down; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }

      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Right { move-column-right; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
    }
  '';

  home.packages = with pkgs; [
    fuzzel
    libnotify
    wl-clipboard
  ];

  home.stateVersion = "26.05";
}
