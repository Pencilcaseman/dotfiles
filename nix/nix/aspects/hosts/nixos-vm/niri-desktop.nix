{
  den.aspects.nixos-vm-niri-desktop = {
    homeManager = { ... }: {
      programs.niri.settings = {
        input = {
          keyboard.repeat-delay = 200;
          keyboard.repeat-rate = 35;

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
          {
            command = [
              "noctalia-shell"
            ];
          }
        ];

        screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png";

        binds = {
          "Mod+Return".action.spawn = "kitty";
          "Mod+Q".action.close-window = {};
          "Mod+F".action.maximize-column = {};

          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+J".action.focus-window-down = {};

          "Mod+Shift+Left".action.move-column-left = {};
          "Mod+Shift+Right".action.move-column-right = {};
          "Mod+Shift+Up".action.move-window-up = {};
          "Mod+Shift+Down".action.move-window-down = {};
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+J".action.move-window-down = {};

          "Mod+W".action.switch-preset-column-width = {};
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;

          "Mod+Tab".action.open-overview = {};

          "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
          "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
          "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];

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
