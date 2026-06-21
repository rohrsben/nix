{
  den.aspects.waybar = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.waybar ];
      xdg.configFile.waybar = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
