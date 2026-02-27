{ inputs }:
final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or []);

    cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DENABLE_LTO=ON"
    ];

    NIX_CFLAGS_COMPILE = "-O3 -march=native -flto -fPIC -fno-plt -fomit-frame-pointer -DNDEBUG -ffunction-sections -fdata-sections";
    NIX_CXXFLAGS_COMPILE = "-O3 -march=native -flto -fPIC -fno-plt -fomit-frame-pointer -DNDEBUG -ffunction-sections -fdata-sections";
  });

  neovim = prev.wrapNeovim final.neovim-unwrapped {
    viAlias = false;
    vimAlias = false;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
