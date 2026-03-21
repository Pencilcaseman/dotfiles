final: prev:
let
  llvm = prev.buildPackages.llvmPackages_latest;
  customStdenv = prev.overrideCC llvm.stdenv (
    llvm.stdenv.cc.override {
      bintools = llvm.bintools;
    }
  );

  archOptFlags =
    if prev.stdenv.hostPlatform.isAarch64
    then [ "-mcpu=native" ]
    else [ "-march=native" "-mtune=native" ];
in
{
  firefox-unwrapped = (prev.firefox-unwrapped.override {
    stdenv = customStdenv;
    ltoSupport = true;
  }).overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      llvm.lld
    ];

    configureFlags = (oldAttrs.configureFlags or []) ++ [
      "--enable-optimize=-O3"
      "--enable-release"
    ];

    NIX_CFLAGS_COMPILE = toString ([
      "-O3"
      "-fPIC"
      "-DNDEBUG"
      "-fomit-frame-pointer"
      "-Wno-error"
    ] ++ archOptFlags);

    requiredSystemFeatures = (oldAttrs.requiredSystemFeatures or []) ++ [ "big-parallel" ];
  });

  firefox = prev.wrapFirefox final.firefox-unwrapped {};
}
