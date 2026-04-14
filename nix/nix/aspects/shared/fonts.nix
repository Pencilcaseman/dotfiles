{
  den.aspects.fonts = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        # Sans-serif
        inter
        noto-fonts
        source-sans

        # Serif
        newcomputermodern
        source-serif
        tex-gyre.adventor
        tex-gyre.bonum
        tex-gyre.chorus
        tex-gyre.cursor
        tex-gyre.heros
        tex-gyre.pagella
        tex-gyre.schola
        tex-gyre.termes
        tex-gyre-math.bonum
        tex-gyre-math.pagella
        tex-gyre-math.schola
        tex-gyre-math.termes

        # Monospace
        nerd-fonts.monaspace
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        source-code-pro

        # CJK and emoji
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];
    };
  };
}
