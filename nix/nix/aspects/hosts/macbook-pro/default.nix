{ den, ... }:
{
  den.aspects.macbook-pro = {
    includes = [
      den.aspects.nixpkgs-base
      den.aspects.macbook-pro-homebrew
      den.aspects.macbook-pro-macos-defaults
    ];

    darwin = { pkgs, ... }: {
      networking = {
        applicationFirewall = {
          enable = true;
          enableStealthMode = true;
        };
      };

      programs = {
        _1password.enable = true;
        _1password-gui.enable = true;
        zsh.enable = true;
      };

      environment.systemPackages = [ pkgs.vim pkgs.git ];
    };
  };
}
