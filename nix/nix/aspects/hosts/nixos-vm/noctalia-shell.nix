{ inputs, ... }:
{
  den.aspects.nixos-vm-noctalia-shell = {
    homeManager = { pkgs, ... }: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      systemd.user.services.noctalia-shell = {
        Unit = {
          Description = "Noctalia desktop shell";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.quickshell}/bin/qs -c noctalia-shell";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      programs.noctalia-shell = {
        enable = true;

        settings = {
          bar = {
            density = "compact";
            position = "left";
            showCapsule = true;

            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  id = "Network";
                }
                {
                  id = "Bluetooth";
                }
              ];

              center = [
                {
                  hideUnoccupied = false;
                  id = "Workspace";
                  labelMode = "none";
                }
              ];

              right = [
                {
                  alwaysShowPercentage = true;
                  id = "Battery";
                  warningThreshold = 30;
                }
                {
                  formatHorizontal = "HH:mm";
                  formatVertical = "HH mm";
                  id = "Clock";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
              ];
            };
          };

          colorSchemes.predefinedScheme = "Noctalia-default";

          general = {
            # avatarImage = "/home/drfoobar/.face";
            radiusRatio = 0.2;
          };

          location = {
            monthBeforeDay = false;
            name = "London, England";
          };
        };
      };
    };
  };
}
