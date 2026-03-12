{ pkgs, lib, modulesPath, ... }:
{
  nix.package = pkgs.lix;
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = let
    optimizedKernel = pkgs.linuxPackages_latest.kernel.override {
      structuredExtraConfig = with lib.kernel; {
        # Compiler optimizations
        CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
        LTO_CLANG_FULL = yes;

        # Preemption — full preempt for lowest latency
        PREEMPT = lib.mkForce yes;
        PREEMPT_VOLUNTARY = lib.mkForce no;

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

        # BBR TCP congestion control
        TCP_CONG_BBR = yes;
        DEFAULT_BBR = yes;

        # ZRAM compressed swap
        ZRAM = lib.mkForce yes;
        ZRAM_DEF_COMP_ZSTD = lib.mkForce yes;
        ZSWAP = lib.mkForce yes;

        # Compiler dead code elimination
        LD_DEAD_CODE_DATA_ELIMINATION = yes;

        # futex2 for better userspace synchronization
        FUTEX = yes;
        FUTEX_PI = yes;

        # Control group optimizations
        CGROUP_BPF = yes;
        BPF_SYSCALL = yes;

        # DAMON memory monitoring
        DAMON = yes;
        DAMON_VADDR = yes;
        DAMON_PADDR = yes;
        DAMON_RECLAIM = yes;

        LOCALVERSION = freeform "-optimized";
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
    shell = pkgs.zsh;
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
