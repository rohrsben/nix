{
  den.aspects.hypridle = {
    homeManager = { pkgs, lib, ... }: {
      xdg.configFile."hypr/hypridle.conf".source = ./config/hypridle.conf;
      systemd.user.services.hypridle = {
        Unit = {
            Description = "Hypridle";
            After = "graphical-session.target";
            PartOf = "graphical-session.target";
        };
        Service = {
            ExecStart = "${lib.getExe pkgs.hypridle}";
            Restart = "always";
            RestartSec = "5";
        };
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
