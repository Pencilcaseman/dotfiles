{
  den.aspects.macbook-pro-homebrew = {
    darwin = {
      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };

        taps = [
          "homebrew/services"
        ];

        brews = [
          "mas"
        ];

        casks = [
          "floorp"
          "ghostty"
          "mac-mouse-fix"
          "monarch"
          "claude"
        ];

        masApps = {
          "Xcode" = 497799835;
        };
      };
    };
  };
}
