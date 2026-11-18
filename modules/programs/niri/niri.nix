{
  den.aspects.niri = {
    nixos = {
      programs.niri.enable = true;
    };

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.xwayland-satellite pkgs.kdePackages.polkit-kde-agent-1 ];

      xdg.configFile.niri = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
