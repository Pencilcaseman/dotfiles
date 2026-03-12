{ inputs, ... }:
{
  imports = [
    (inputs.den.flakeModule or { })
  ];
}
