final: prev:
let
  optimizedRustFlags = toString [
    "-C opt-level=3"
    "-C target-cpu=native"
    "-C lto=fat"
    "-C codegen-units=1"
    "-C llvm-args=-polly"
  ];

  optimizedCargo = prev.symlinkJoin {
    name = "cargo-optimized-${prev.cargo.version}";
    paths = [ prev.cargo ];
    nativeBuildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/cargo \
        --suffix CARGO_BUILD_RUSTFLAGS " " "${optimizedRustFlags}"
    '';
  };
in
{
  rustPlatform = prev.rustPlatform // {
    buildRustPackage = prev.rustPlatform.buildRustPackage.override {
      cargo = optimizedCargo;
    };
  };
}
