{ pkgs, inputs, ... }: {
  nix.package = pkgs.lix;
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "root" "tobydavis" ];
    substituters = [ "https://cache.lix.systems" ];
    trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
  };

  # User
  system.primaryUser = "tobydavis";
  users.users.tobydavis = {
     name = "tobydavis";
     home = "/Users/tobydavis";
  };

  # Should be the same as the system name
  networking.hostName = "Tobys-MacBook-Pro";

  # macOS Defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.NewWindowTarget = "Home";
    NSGlobalDomain.AppleShowAllExtensions = true;
    menuExtraClock.Show24Hour = true;
  };

  # Global system packages
  environment.systemPackages = [ pkgs.vim pkgs.git ];

  # Zsh is required on macOS regardless of other shells used
  programs.zsh.enable = true;

  # Homebrew
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];

    brews = [
      "mas" # Mac App Store CLI
    ];

    casks = [
      "floorp"
      "ghostty"
      "raycast"

      # "netbirdio/tap/netbird-ui" # Installed as an app
    ];

    # Get app ID by running `mas search <app name>` in terminal
    masApps = {
      "Xcode" = 497799835;
    };
  };

  # Nix-Darwin state version.
  # DO NOT CHANGE WITHOUT READING CHANGELOG!
  system.stateVersion = 5;
}
