{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, fetchzip
, cmake
, pkg-config
, ninja
, python3
, zlib
, libffi
, libxml2
, fmt
, llvmPackages
, gfortran
, darwin
}:
let
  # Exaloop has a custom LLVM fork with some changes to OpenMP.
  # See https://docs.exaloop.io/developers/build/
  exaloop-llvm = stdenv.mkDerivation {
    pname = "exaloop-llvm";
    version = "20-codon";

    src = fetchFromGitHub {
      owner = "exaloop";
      repo = "llvm-project";
      rev = "codon";
      hash = "sha256-M3NavyWrG3KveYnPRoWHkDd/G2uFwYzRoGUUvo2sOcg=";
    };

    nativeBuildInputs = [ cmake ninja python3 gfortran ];
    buildInputs = [ zlib libffi libxml2 ];

    sourceRoot = "source/llvm";

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_ENABLE_RTTI=ON"
      "-DLLVM_ENABLE_ZLIB=OFF"
      "-DLLVM_ENABLE_ZSTD=OFF"
      "-DLLVM_ENABLE_PROJECTS='clang;openmp'"
      "-DLLVM_TARGETS_TO_BUILD=all"
    ];

    enableParallelBuilding = true;

    meta = with lib; {
      description = "Exaloop's LLVM fork with OpenMP GC hooks for Codon";
      homepage = "https://github.com/exaloop/llvm-project";
      license = licenses.asl20;
    };
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  peglib = fetchFromGitHub {
    owner = "exaloop";
    repo = "cpp-peglib";
    rev = "codon";
    hash = "sha256-JKywhV6XGI4qGznTUa8XCnEx7wkKoM2RTylT+PszxQY=";
  };

  highway = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = "ac0d5d297b13ab1b89f48484fc7911082d76a93f";
    hash = "sha256-8QOk96Y3GIIvBUGIDikMgTylx8y5aCyr68/TP5w5ha4=";
  };

  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "03597a01ee50ed33e9dfd640b249b4be3799d395";
    hash = "sha256-N/5Q4mqErusWRiG/OKLXKi6v96kgJzv8qTPEJR2uRLs=";
  };

  bdwgc = fetchFromGitHub {
    owner = "exaloop";
    repo = "bdwgc";
    rev = "e16c67244aff26802203060422545d38305e0160";
    hash = "sha256-FGrTsA+A6mUQ92ceHzL67vYKyBZC2LRXLcpy5pRyJTc=";
  };

  backtrace = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "d0f5e95a87a4d3e0a1ed6c069b5dae7cbab3ed2a";
    hash = "sha256-rK9BHaht1d8dYWaBIeJSFPgWlm4t4yLN8GwCwBJlGa0=";
  };

  zlibng = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = "2.0.5";
    hash = "sha256-KvV1XtPoagqPmijdr20eejsXWG7PRjMUwGPLXazqUHM=";
  };

  semver = fetchFromGitHub {
    owner = "Neargye";
    repo = "semver";
    rev = "v0.3.0";
    hash = "sha256-nRWmY/GJtSkPJIW7i7/eIr/YtfyvYhJVZBRIDXUC7xg=";
  };

  fast_float = fetchFromGitHub {
    owner = "fastfloat";
    repo = "fast_float";
    rev = "v6.1.1";
    hash = "sha256-acaTUI+SWKSgmyJ+J4PzR5U7UtunbRiVuf5OsTf1Hko=";
  };

  xz = fetchFromGitHub {
    owner = "xz-mirror";
    repo = "xz";
    rev = "e7da44d5151e21f153925781ad29334ae0786101";
    hash = "sha256-qeI0ZABy8naQtxJejL8ufIzwisUmYJzhyOG6YAQTe+4=";
  };

  bz2 = fetchzip {
    url = "https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz";
    hash = "sha256-Uvi4JZPPERK3gym4yoaeTEJwKXF5brBAEN7GgF+iF6g=";
  };

  toml = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "v3.2.0";
    hash = "sha256-nohO4eySs73BSgjvq+uzybiE5lw2rFY5YqGbl/oqGek=";
  };

  re2 = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "5723bb8950318135ed9cf4fc76bed988a087f536";
    hash = "sha256-UontAjOXpnPcOgoFHjf+1WSbCR7h58/U7nn4meT200Y=";
  };
in
stdenv.mkDerivation rec {
  pname = "codon";
  version = "0.19.5";

  src = fetchFromGitHub {
    owner = "exaloop";
    repo = "codon";
    rev = "v${version}";
    hash = "sha256-fftCaLPcjkO33rTmXhVawVpqfrIDs7lN7fJk456ahwo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.sigtool
  ];

  buildInputs = [
    exaloop-llvm
    zlib
    libffi
    libxml2
    fmt
  ];

  # Patch deps.cmake to add exaloop/openmp as a subdirectory build.
  postPatch = ''
    # Append an imported omp target to deps.cmake.
    # When exaloop-llvm is built with LLVM_ENABLE_PROJECTS=openmp, it
    # installs lib/libomp.dylib (or .so) alongside the LLVM cmake config.
    cat >> cmake/deps.cmake << 'OPENMP_EOF'

    # -- Imported omp target from exaloop-llvm --
    if(NOT TARGET omp)
      add_library(omp SHARED IMPORTED)
      if(APPLE)
        set(_omp_lib "$\{LLVM_TOOLS_BINARY_DIR\}/../lib/libomp.dylib")
      else()
        set(_omp_lib "$\{LLVM_TOOLS_BINARY_DIR\}/../lib/libomp.so")
      endif()
      set_target_properties(omp PROPERTIES
        IMPORTED_LOCATION "$\{_omp_lib\}"
      )
    endif()
    OPENMP_EOF
  '';

  preConfigure = ''
    mkdir -p build/cmake
    cp ${cpm} build/cmake/CPM_0.40.8.cmake

    mkdir -p build/_deps/backtrace-src
    cp -R --no-preserve=mode,ownership ${backtrace}/. build/_deps/backtrace-src
    chmod -R u+w build/_deps/backtrace-src

    cmakeFlagsArray+=(
      "-DCPM_backtrace_SOURCE=$(pwd)/build/_deps/backtrace-src"
      "-DCODON_SYSTEM_LIBRARIES=${gfortran.cc.lib}/lib"
    )

    export CODON_SYSTEM_LIBRARIES=${gfortran.cc.lib}/lib
  '';

  # Codon has an issue on macOS with an incorrect path
  preInstall = ''
    mkdir -p scripts
    # We are in the build directory during install hooks
    cp -v ../scripts/fix_loader_paths.sh scripts/fix_loader_paths.sh
    chmod +x scripts/fix_loader_paths.sh
  '';

  postInstall = ''
    # Codon installs its own dylibs under $out/lib/codon.
    # Some builds look for $out/lib/libcodonc.dylib directly; provide a compat
    # symlink for Codon's own dylibs (no libomp/libgfortran/etc).
    mkdir -p "$out/lib"

    for name in libcodonc.dylib libcodonrt.dylib libcodon_jupyter.dylib; do
      if [ -e "$out/lib/codon/$name" ]; then
        ln -sf "$out/lib/codon/$name" "$out/lib/$name"
      fi
    done
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath "$out/lib/codon" "$out/bin/codon" 2>/dev/null || true
    install_name_tool -add_rpath "${llvmPackages.openmp}/lib" "$out/bin/codon" 2>/dev/null || true
    install_name_tool -add_rpath "${gfortran.cc.lib}/lib" "$out/bin/codon" 2>/dev/null || true
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_DIR=${exaloop-llvm.dev or exaloop-llvm}/lib/cmake/llvm"
    "-DCODON_BUILD_TESTS=OFF"

    "-DCPM_USE_LOCAL_PACKAGES=ON"
    "-DCPM_DOWNLOAD_ALL=OFF"
    "-DCPM_SOURCE_CACHE=build"

    "-DCPM_peglib_SOURCE=${peglib}"
    "-DCPM_highway_SOURCE=${highway}"
    "-DCPM_googletest_SOURCE=${googletest}"
    "-DCPM_bdwgc_SOURCE=${bdwgc}"
    "-DCPM_zlibng_SOURCE=${zlibng}"
    "-DCPM_semver_SOURCE=${semver}"
    "-DCPM_fast_float_SOURCE=${fast_float}"
    "-DCPM_xz_SOURCE=${xz}"
    "-DCPM_bz2_SOURCE=${bz2}"
    "-DCPM_toml_SOURCE=${toml}"
    "-DCPM_re2_SOURCE=${re2}"

    "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=${googletest}"

    # Bypass Highway's FindAtomics.cmake — aarch64 has native lock-free atomics
    # but the check fails in the Nix sandbox
    "-DATOMICS_LOCK_FREE_INSTRUCTIONS=ON"
  ];

  meta = with lib; {
    description = "A high-performance Python compiler using LLVM";
    homepage = "https://github.com/exaloop/codon";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
