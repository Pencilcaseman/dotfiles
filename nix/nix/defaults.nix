{ den, ... }:
{
  # flake-parts systems for perSystem modules
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  # Global defaults
  den.default = {
    darwin.system.stateVersion = 5;
    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";
  };

  den.default.includes = [
    den.provides.mutual-provider
    den.provides.hostname
    den.provides.define-user
  ];
}
