{
  den.aspects.mako = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.mako ];
      xdg.configFile.mako = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
