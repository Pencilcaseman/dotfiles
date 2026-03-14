{ inputs }:
final: prev:
let
  llvm = prev.buildPackages.llvmPackages_latest;
  customStdenv = prev.overrideCC llvm.stdenv (
    llvm.stdenv.cc.override {
      bintools = llvm.bintools;
    }
  );
in
{
  neovim-unwrapped = (prev.neovim-unwrapped.override {
    stdenv = customStdenv;
  }).overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      llvm.lld
    ];

    cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DENABLE_LTO=ON"
    ];

    NIX_CFLAGS_COMPILE = toString [
      "-O3"
      "-march=native"
      "-flto"
      "-fPIC"
      "-fomit-frame-pointer"
      "-DNDEBUG"
      "-ffunction-sections"
      "-fdata-sections"
      "-Wno-error"
    ];
  });

  neovim = prev.wrapNeovim final.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
  };
}
