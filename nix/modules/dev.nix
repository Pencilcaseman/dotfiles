{ pkgs, lib, inputs, ... }: {
  home.packages = with pkgs; [
    # Build Tools
    cmake
    gnumake
    ninja
    pkg-config

    # Libraries
    opencv
    glew
    llvmPackages.openmp

    # Python
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests

      numpy

      matplotlib

      pandas
      polars
    ]))
    pypy3
    # codon
    uv
    basedpyright
    ruff

    # Rust
    rustup
    # release-plz

    cargo-audit
    cargo-binstall
    cargo-cache
    cargo-edit
    cargo-expand
    cargo-msrv
    cargo-pgo
    cargo-release
    cargo-show-asm
    cargo-update

    # Node/JS
    nodejs_24
    typescript
    # deno

    # Java
    jdk
    gradle
    maven

    # Typesetting
    texliveFull
    tectonic
    typst

    # AI
    claude-code # For emergencies only...
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # On macOS we rely on AppleClang
    (lib.lowPrio gcc)
    (lib.hiPrio clang)
  ];
}
