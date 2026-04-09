final: prev:
let
  optimizedRustFlags = toString [
    "-C opt-level=3"
    "-C target-cpu=native"
    "-C lto=fat"
    "-C codegen-units=1"
    "-C llvm-args=-polly"
  ];

  optimize = pkg: pkg.overrideAttrs (old: {
    CARGO_BUILD_RUSTFLAGS = "${old.CARGO_BUILD_RUSTFLAGS or ""} ${optimizedRustFlags}";
  });

  optimizedPackages = [
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
    "typst"
  ];
in
builtins.listToAttrs (map (name: {
  inherit name;
  value = optimize prev.${name};
}) optimizedPackages)
