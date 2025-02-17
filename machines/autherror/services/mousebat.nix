{ pkgs, ... }:

let
    mkdir =  "${pkgs.coreutils}/bin/mkdir";
    head =   "${pkgs.coreutils}/bin/head";
    cut =    "${pkgs.coreutils}/bin/cut";
    solaar = "${pkgs.solaar}/bin/solaar";
    rg =     "${pkgs.ripgrep}/bin/rg";
    outputs = "/home/error/.scripts/outputs";
in {
    systemd.timers."mouseBat" = {
        description = "mouseBat Timer";

        wantedBy = [ "timers.target" ];

        timerConfig = {
            Unit = "mouseBat.service";
            OnBootSec = "10min";
            OnUnitActiveSec = "2h";
        };
    };

    systemd.services."mouseBat" = {
        script = ''
            set -eu
            ${mkdir} -p ${outputs}

            output=$(${solaar} show G502 | ${rg} --trim --max-count=1 Battery | ${cut} -c 10-11)
            if [ ! -z "$output" ]
                then
                    echo "$output" > ${outputs}/mouseBat
                    fi
        '';

        serviceConfig = {
            Type = "oneshot";
            User = "root";
        };
    };
}
