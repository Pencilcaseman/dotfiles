{ pkgs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = let
    llvmPkgs = pkgs.buildPackages.llvmPackages_latest;
    stdenvLLVM = pkgs.overrideCC llvmPkgs.stdenv llvmPkgs.clangUseLLVM;
    optimizedKernel = pkgs.linuxPackages_latest.kernel.override {
      stdenv = stdenvLLVM;

      extraMakeFlags = [
        "LLVM=1"
        "KCFLAGS=-O3"
      ];

      structuredExtraConfig = with lib.kernel; {
        # Clang full LTO
        LTO_NONE = lib.mkForce no;
        LTO_CLANG_FULL = lib.mkForce yes;

        # 1000Hz tick for responsive scheduling
        HZ_1000 = yes;
        HZ = freeform "1000";

        # Tickless idle — reduce timer overhead when idle
        NO_HZ_FULL = yes;

        # MGLRU — improved page reclaim for better memory performance
        LRU_GEN = yes;
        LRU_GEN_ENABLED = yes;

        # Zstd compression for kernel and initramfs
        KERNEL_ZSTD = yes;
        RD_ZSTD = yes;

        # BBR TCP congestion control + fair queue scheduler
        TCP_CONG_BBR = yes;
        DEFAULT_BBR = yes;
        NET_SCH_FQ = yes;

        # ZRAM compressed swap
        ZRAM = lib.mkForce yes;
        ZRAM_DEF_COMP_ZSTD = lib.mkForce yes;
        ZSWAP = lib.mkForce yes;

        # Scheduling
        SCHED_AUTOGROUP = yes;

        # BPF (enables sched-ext and cgroup BPF)
        CGROUP_BPF = yes;
        BPF_SYSCALL = yes;
        BPF_JIT = yes;
        DEBUG_INFO_BTF = yes;
        SCHED_CLASS_EXT = yes;

        # futex for better userspace synchronization
        FUTEX = yes;
        FUTEX_PI = yes;

        # DAMON memory monitoring and reclaim
        DAMON = yes;
        DAMON_VADDR = yes;
        DAMON_PADDR = yes;
        DAMON_RECLAIM = yes;

        # THP in madvise mode (avoids compaction latency spikes)
        TRANSPARENT_HUGEPAGE = yes;
        TRANSPARENT_HUGEPAGE_MADVISE = yes;
      };

      autoModules = true;
      ignoreConfigErrors = true;
    };
  in pkgs.linuxPackagesFor optimizedKernel;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  programs.niri.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  hardware.graphics.enable = true;

  users.users.tobydavis = {
    isNormalUser = true;
    description = "Toby Davis";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.nushell;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    kitty
    xwayland-satellite
  ];

  system.stateVersion = "26.05";
}
