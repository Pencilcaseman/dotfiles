{ config, pkgs, ... }:

{
  imports = [
    ../../modules/shell/shell.nix
    ../../modules/cli.nix
    ../../modules/apps.nix
    ../../modules/dev.nix
  ];

  home.username = "tobydavis";
  home.homeDirectory = "/Users/tobydavis";
  home.stateVersion = "26.05";

  home.sessionVariables.SDKROOT = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";

  # macOS-specific applications
  home.packages = with pkgs; [
    # ...
  ];
}
