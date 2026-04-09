final: prev:
let
  llvm = prev.buildPackages.llvmPackages_latest;
  stdenv = if prev.stdenv.hostPlatform.isDarwin
    then prev.overrideCC prev.stdenv llvm.clang
    else prev.overrideCC llvm.stdenv (llvm.stdenv.cc.override { bintools = llvm.bintools; });

  baseCFlags = toString [
    "-O3"
    "-march=native"
    "-fno-plt"
    "-fomit-frame-pointer"
    "-fno-math-errno"
    "-fno-semantic-interposition"
    "-DNDEBUG"
    "-Wno-error"
  ];

in
{
  luajit = (prev.luajit.override { inherit stdenv; }).overrideAttrs {
    env.NIX_CFLAGS_COMPILE = baseCFlags;
  };

  neovim-unwrapped = (prev.neovim-unwrapped.override { inherit stdenv; }).overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [ prev.jemalloc ];
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DENABLE_LTO=ON"
      "-DCMAKE_EXE_LINKER_FLAGS=-ljemalloc"
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
