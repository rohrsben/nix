{
  den.aspects.greeter = {
    nixos = { pkgs, ... }: {
      services.displayManager.noctalia-greeter = {
        enable = true;
        cursorTheme = {
          package = pkgs.phinger-cursors;
          name = "phinger-cursors-dark";
        };

        settings = {
          appearance = {
            scheme = "Gruvbox";
            hide_logo = true;
            font_family = "JetBrains Mono";
          };

          output = {
            name = "DP-3";
            refresh_rate = 120;
          };

          cursor.size = 24;
        };
      };
    };
  };
}
