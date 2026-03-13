{ inputs, lib, pkgs, ... }:
{
  den.aspects.nixos-vm-optimized-kernel = {
    nixos = { pkgs, lib, ... }:
      let
        llvm = pkgs.buildPackages.llvmPackages_latest;
        stdenvLLVM = pkgs.overrideCC llvm.stdenv (
          llvm.stdenv.cc.override {
            bintools = llvm.bintools;
          }
        );
        optimizedKernel = (pkgs.linuxPackages_latest.kernel.override {
          stdenv = stdenvLLVM;
          extraMakeFlags = [ "LLVM=1" ];
          structuredExtraConfig = with lib.kernel; {
            LTO_NONE = lib.mkForce no;
            LTO_CLANG_FULL = lib.mkForce yes;
            LRU_GEN = yes;
            LRU_GEN_ENABLED = yes;
            SCHED_AUTOGROUP = yes;
            DEBUG_INFO_BTF = yes;
            SCHED_CLASS_EXT = yes;
            FUTEX = yes;
            FUTEX_PI = yes;
            TRANSPARENT_HUGEPAGE = yes;
            TRANSPARENT_HUGEPAGE_MADVISE = yes;
          };
          autoModules = true;
          ignoreConfigErrors = true;
        }).overrideAttrs (old: {
          env.NIX_CFLAGS_COMPILE = "-Wno-unused-command-line-argument";
          makeFlags = (old.makeFlags or []) ++ [
            "KCFLAGS=-O3 -march=native"
            "KCPPFLAGS=-O3 -march=native"
            "LD=ld.lld"
            "AR=llvm-ar"
            "NM=llvm-nm"
            "STRIP=llvm-strip"
            "OBJCOPY=llvm-objcopy"
            "OBJDUMP=llvm-objdump"
            "READELF=llvm-readelf"
            "HOSTLD=ld.lld"
            "HOSTAR=llvm-ar"
          ];
        });
      in
      {
        boot.kernelPackages = pkgs.linuxPackagesFor optimizedKernel;
      };
  };
}

# Waiting for CachyOS to add arm64 support
#
# { inputs, ... }:
# {
#   den.aspects.nixos-vm-optimized-kernel = {
#     nixos = { pkgs, ... }:
#     let
#       kernel = (pkgs.cachyosKernels.linux-cachyos-latest.override {
#         configVariant = "linux-cachyos-bore";
#         lto = "full";
#         processorOpt = "native";
#         autofdo = true;
#       }).overrideAttrs { meta.broken = false; };
#
#       helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
#     in {
#       boot.kernelPackages = helpers.kernelModuleLLVMOverride (
#         pkgs.linuxKernel.packagesFor kernel
#       );
#     };
#   };
# }
