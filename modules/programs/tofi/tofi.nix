{
  den.aspects.tofi = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.tofi ];
      xdg.configFile.tofi = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
