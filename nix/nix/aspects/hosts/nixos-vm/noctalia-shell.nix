{ inputs, ... }:
{
  den.aspects.nixos-vm-noctalia-shell = {
    homeManager = { ... }: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

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
