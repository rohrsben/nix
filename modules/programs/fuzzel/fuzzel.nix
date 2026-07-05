{
  den.aspects.fuzzel = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.fuzzel ];
      xdg.configFile.fuzzel = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
