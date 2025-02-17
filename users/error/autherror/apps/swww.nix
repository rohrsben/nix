{ inputs, pkgs, config, ... }:

let
    swwwDaemon = "${inputs.swww.packages.${pkgs.system}.swww}/bin/swww-daemon";
    backgrounds = "/home/error/nix/users/error/hm/apps/config/outofstore/backgrounds/";
in {
    systemd.user.services.swwwDaemon = {
        Unit = {
            Description = "Swww Daemon";
            After = "graphical-session.target";
            BindsTo = "graphical-session.target";
            PartOf = "graphical-session.target";
        };

        Service = {
            Type = "exec";
            ExecStart = "${swwwDaemon}";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
