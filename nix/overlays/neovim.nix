{ inputs }:
final: prev:
let
  llvm = prev.buildPackages.llvmPackages_latest;
  customStdenv = prev.overrideCC llvm.stdenv (
    llvm.stdenv.cc.override {
      bintools = llvm.bintools;
    }
  );

  optimizedCFlags = toString [
    "-O3"
    "-march=native"
    "-flto"
    "-fPIC"
    "-fomit-frame-pointer"
    "-DNDEBUG"
    "-Wno-error"
  ];
in
{
  luajit = prev.luajit.overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or {}) // {
      NIX_CFLAGS_COMPILE = optimizedCFlags;
    };
  });

  tree-sitter = (prev.tree-sitter.override {
    stdenv = customStdenv;
  }).overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or {}) // {
      NIX_CFLAGS_COMPILE = optimizedCFlags;
    };
  });

  neovim-unwrapped = (prev.neovim-unwrapped.override {
    stdenv = customStdenv;
  }).overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      llvm.lld
    ];

    buildInputs = (oldAttrs.buildInputs or []) ++ [
      final.mimalloc
    ];

    cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DENABLE_LTO=ON"
    ];

    env = (oldAttrs.env or {}) // {
      NIX_CFLAGS_COMPILE = optimizedCFlags;
      NIX_LDFLAGS = "-lmimalloc";
    };
  });

  neovim = prev.wrapNeovim final.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
  };
}
