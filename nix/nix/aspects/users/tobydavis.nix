{ den, ... }:
{
  den.aspects.tobydavis = {
    includes = [
      den.aspects.cli-tools
      den.aspects.dev-toolchain
      den.aspects.gui-apps
      den.aspects.nushell-env
      den.provides.primary-user
    ];

    homeManager = { ... }: {
      home.username = "tobydavis";
    };

    nixos = { pkgs, ... }: {
      users.users.tobydavis.shell = pkgs.nushell;
    };

    # Per-host overrides
    provides.macbook-pro = {
      homeManager = { ... }: {
        home.homeDirectory = "/Users/tobydavis";
        home.sessionVariables.SDKROOT = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
      };
    };

    provides.nixos-vm = {
      includes = [
        den.aspects.nixos-vm-niri-desktop
        den.aspects.nixos-vm-dms-shell
      ];

      homeManager = { pkgs, ... }: {
        home.homeDirectory = "/home/tobydavis";
        home.packages = [ pkgs.wl-clipboard ];
      };
    };
  };
}
