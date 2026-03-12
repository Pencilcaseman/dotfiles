{ inputs, ... }:
{
  den.aspects.nixos-vm-dms-shell = {
    homeManager = { ... }: {
      imports = [
        inputs.dms-shell.homeModules.dank-material-shell
        inputs.dms-plugin-registry.homeModules.default
      ];

      programs.dank-material-shell = {
        enable = true;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        enableSystemMonitoring = true;
        enableVPN = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;
        enableClipboardPaste = true;
      };
    };
  };
}
