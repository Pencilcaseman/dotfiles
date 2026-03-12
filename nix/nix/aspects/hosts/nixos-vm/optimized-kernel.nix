{ inputs, ... }:
{
  den.aspects.nixos-vm-optimized-kernel = {
    nixos = { pkgs, ... }:
    let
      kernel = (pkgs.cachyosKernels.linux-cachyos-latest.override {
        lto = "full";
        processorOpt = "native";
        autofdo = true;
      }).overrideAttrs { meta.broken = false; };

      helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
    in {
      boot.kernelPackages = helpers.kernelModuleLLVMOverride (
        pkgs.linuxKernel.packagesFor kernel
      );
    };
  };
}
