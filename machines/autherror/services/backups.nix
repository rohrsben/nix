{ pkgs, ... }:

{
    systemd.timers."homeBackup" = {
        description = "Home dir backup";

        wantedBy = [ "timers.target" ];

        timerConfig = {
            Unit = "homeBackup.service";
            OnCalendar = "daily";
            Persistent = true;
        };
    };

    systemd.services."homeBackup" = {
        path = [
            pkgs.coreutils
            pkgs.ripgrep
            pkgs.btrfs-progs
        ];

        script = ''
            set -eu

            backupsDir="/mnt/lts/backups/home"

            mkdir /tmp/homeBackup
            cd /tmp/homeBackup

            name="daily-$(date +"%y.%m.%d")"

            btrfs subvolume snapshot -r /home "$name"
            btrfs send "$name" | btrfs receive "$backupsDir"
            btrfs subvolume delete "$name"

            cd "$backupsDir"

            while [ "$(ls | rg -c daily)" -gt 3 ]; do
                current="$(ls | sort | head -n 1)"
                if (( ''${current: -2} % 7 == 1 )); then
                    mv "$current" "''${current//daily/weekly}"
                else
                    btrfs subvolume delete "$current"
                fi
            done

            while [ "$(ls | rg -c weekly)" -gt 3 ]; do
                current="$(ls | sort | head -n 1)"
                if [[ ''${current: -2} == "01" ]]; then
                    mv "$current" "''${current//weekly/monthly}"
                else
                    btrfs subvolume delete "$current"
                fi
            done

            while [ "$(ls | rg -c monthly)" -gt 3 ]; do
                btrfs subvolume delete "$(ls | sort | head -n 1)"
            done
        '';

        serviceConfig = {
            Type = "oneshot";
            User = "root";
        };
    };
}
