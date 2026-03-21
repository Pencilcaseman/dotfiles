{ inputs }:
[
  (import ./codon.nix)
  (import ./firefox.nix)
  (import ./neovim.nix { inherit inputs; })
]
