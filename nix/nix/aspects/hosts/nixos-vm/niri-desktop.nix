{
  den.aspects.nixos-vm-niri-desktop = {
    homeManager = { ... }: {
      programs.niri.settings = {
        input = {
          # A bit dodgy in the VM
          keyboard.repeat-delay = 300;
          keyboard.repeat-rate = 40;

          touchpad = {
            natural-scroll = false;
            tap = false;
            dwt = true;
            accel-profile = "adaptive";
          };

          mouse = {
            natural-scroll = true;
            accel-profile = "adaptive";
          };

          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = true;
        };

        outputs = {
          "Virtual-1".scale = 2.0;
        };

        cursor = {
          size = 32;
          hide-when-typing = true;
        };

        layout = {
          gaps = 8;
          center-focused-column = "on-overflow";

          border = {
            enable = true;
            width = 2;
            active.color = "#007AFF";
            inactive.color = "#3A3A3C";
          };

          focus-ring.enable = false;

          preset-column-widths = [
            { proportion = 1.0 / 3.0; }
            { proportion = 1.0 / 2.0; }
            { proportion = 2.0 / 3.0; }
          ];

          default-column-width.proportion = 1.0 / 2.0;
        };

        spawn-at-startup = [
          { command = [ "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1" ]; }
        ];

        screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png";

        binds = {
          # Launch
          "Mod+Return".action.spawn = "kitty";
          "Mod+D".action.spawn = [ "qs" "-c" "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
          "Mod+N".action.spawn = [ "qs" "-c" "noctalia-shell" "ipc" "call" "notifications" "toggleHistory" ];

          # Window management
          "Mod+Q".action.close-window = {};
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = {};
          "Mod+C".action.center-column = {};
          "Mod+Comma".action.consume-window-into-column = {};
          "Mod+Period".action.expel-window-from-column = {};

          # Focus (vim + arrows)
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+J".action.focus-window-down = {};
          "Mod+Left".action.focus-column-left = {};
          "Mod+Right".action.focus-column-right = {};
          "Mod+Up".action.focus-window-up = {};
          "Mod+Down".action.focus-window-down = {};

          # Move windows
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Shift+Left".action.move-column-left = {};
          "Mod+Shift+Right".action.move-column-right = {};
          "Mod+Shift+Up".action.move-window-up = {};
          "Mod+Shift+Down".action.move-window-down = {};

          # Column sizing
          "Mod+W".action.switch-preset-column-width = {};
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";

          # Workspaces
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;
          "Mod+Shift+6".action.move-window-to-workspace = 6;
          "Mod+Shift+7".action.move-window-to-workspace = 7;
          "Mod+Shift+8".action.move-window-to-workspace = 8;
          "Mod+Shift+9".action.move-window-to-workspace = 9;

          "Mod+Tab".action.open-overview = {};

          # Screenshots
          "Print".action.screenshot = {};
          "Mod+Shift+S".action.screenshot-screen = {};

          # Lock screen
          "Mod+Escape".action.spawn = [ "qs" "-c" "noctalia-shell" "ipc" "call" "lockScreen" "lock" ];

          # Media / hardware keys
          "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
          "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
          "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
          "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "set" "+5%" ];
          "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "5%-" ];

          # Session
          "Mod+Shift+E".action.quit = { skip-confirmation = false; };
        };

        window-rules = [
          {
            geometry-corner-radius = let r = 8.0; in { top-left = r; top-right = r; bottom-left = r; bottom-right = r; };
            clip-to-geometry = true;
          }
        ];
      };
    };
  };
}
