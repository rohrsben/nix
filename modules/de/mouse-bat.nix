{
  den.aspects.mousebat = {
    nixos = { pkgs, ... }: {
      systemd = {
        timers.mouseBat = {
          description = "mouseBat Timer";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            Unit = "mouseBat.service";
            OnBootSec = "10min";
            OnUnitActiveSec = "2h";
          };
        };

        services.mouseBat = {
          path = [ pkgs.coreutils pkgs.solaar pkgs.ripgrep ];
          script = ''
            set -eu

            outputs="/home/error/.scripts/outputs"

            mkdir -p "$outputs"

            output=$(solaar show G502 | rg --trim --max-count=1 Battery | cut -c 10-11)
            if [ ! -z "$output" ]; then
              echo "$output" > "$outputs/mouseBat"
            fi
          '';
          serviceConfig = {
            Type = "oneshot";
            User = "root";
          };
        };
      };
    };
  };
}
