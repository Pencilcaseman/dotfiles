{ pkgs, ... }:

let
  # Helper to create nushell scripts
  mkNuScript = name: path: pkgs.writeScriptBin name ''
    #!${pkgs.nushell}/bin/nu
    ${builtins.readFile path}
  '';
in
{
  home.packages = [
    (mkNuScript "nosleep" ./nosleep.nu)
  ];
}
