{
  den.aspects.noctalia = {
    nixos = {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = false;
      };
    };

    homeManager = {
      xdg.configFile.noctalia = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
