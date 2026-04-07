{ inputs }:
final: prev:
let
  llvm = prev.buildPackages.llvmPackages_latest;
  stdenv = llvm.stdenv;

  baseCFlags = toString [
    "-O3"
    "-march=native"
    "-fomit-frame-pointer"
    "-DNDEBUG"
    "-Wno-error"
  ];
in
{
  luajit = (prev.luajit.override { inherit stdenv; }).overrideAttrs {
    env.NIX_CFLAGS_COMPILE = baseCFlags;
  };

  tree-sitter = (prev.tree-sitter.override { inherit stdenv; }).overrideAttrs {
    env.NIX_CFLAGS_COMPILE = baseCFlags;
  };

  neovim-unwrapped = (prev.neovim-unwrapped.override { inherit stdenv; }).overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ llvm.lld ];
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DENABLE_LTO=ON"
      "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld"
      "-DCMAKE_SHARED_LINKER_FLAGS=-fuse-ld=lld"
      "-DCMAKE_MODULE_LINKER_FLAGS=-fuse-ld=lld"
    ];
    env.NIX_CFLAGS_COMPILE = "${baseCFlags} -fPIC";
  });

  neovim = prev.wrapNeovim final.neovim-unwrapped {
    viAlias = false;
    vimAlias = false;
    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
  };
}
