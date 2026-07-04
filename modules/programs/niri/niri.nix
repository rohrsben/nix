{
  den.aspects.niri = {
    nixos = { config, lib, pkgs, ... }: {
      programs.niri.enable = true;

      services.greetd.settings.default_session.command = lib.mkForce "${lib.getExe pkgs.tuigreet} --time --cmd '${config.programs.niri.package}/bin/niri-session'";
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
