final: prev:
let
  optimisedRustFlags = toString [
    "-C opt-level=3"
    "-C target-cpu=native"
    "-C lto=fat"
    "-C codegen-units=1"
    "-C llvm-args=-polly"
  ];

  optimise = pkg: pkg.overrideAttrs (old: {
    CARGO_BUILD_RUSTFLAGS = "${old.CARGO_BUILD_RUSTFLAGS or ""} ${optimisedRustFlags}";
  });

  optimisedPackages = [
    "nushell"
    "starship"
    "nh"
    "ripgrep"
    "ripgrep-all"
    "fd"
    "bat"
    "dust"
    "bottom"
    "zoxide"
    "yazi"
    "zellij"
    "jujutsu"
    "gitoxide"
    "ruff"
    "uv"
    "tree-sitter"
    "typst"
  ];
in
builtins.listToAttrs (map (name: {
  inherit name;
  value = optimise prev.${name};
}) optimisedPackages)
