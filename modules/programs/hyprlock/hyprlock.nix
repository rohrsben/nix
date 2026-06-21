{
  den.aspects.hyprlock = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.hyprlock ];
      xdg.configFile."hypr/hyprlock.conf".source = ./config/hyprlock.conf;
    };
  };
}
