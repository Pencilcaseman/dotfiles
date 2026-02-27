{ inputs }:
[
  (import ./codon.nix)
  (import ./neovim.nix { inherit inputs; })
]
