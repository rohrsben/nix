{ pkgs, ... }:

{
    systemd.timers."homeBackup" = {
        description = "Home dir backup";

        wantedBy = [ "timers.target" ];

        timerConfig = {
            Unit = "homeBackup.service";
            OnCalendar = "daily";
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

            mkdir -p /tmp/homeBackup
            cd /tmp/homeBackup

            name="daily-$(date +"%y.%m.%d")"

            btrfs subvolume snapshot -r /home "$name"
            btrfs send "$name" | btrfs receive "$backupsDir"
            btrfs subvolume delete "$name"

            cd "$backupsDir"

            while [ "$(ls | rg -c daily)" -gt 3 ]; do
                current="$(ls | rg daily | sort | head -n 1)"
                asWeekly="weekly-''${current: 6:6}$(( ((10#''${current: -2} - 1) / 7) + 1 ))"
                if test -d "$asWeekly"; then
                    btrfs subvolume delete "$current"
                else
                    mv "$current" "$asWeekly"
                fi
            done

            while [ "$(ls | rg -c weekly)" -gt 3 ]; do
                current="$(ls | rg weekly | sort | head -n 1)"
                asMonthly="monthly-''${current: 7:5}"
                if test -d "$asMonthly"; then
                    btrfs subvolume delete "$current"
                else
                    mv "$current" "$asMonthly"
                fi
            done

            while [ "$(ls | rg -c monthly)" -gt 3 ]; do
                current="$(ls | rg monthly | sort | head -n 1)"
                asYearly="yearly-''${current: 8:2}"
                if test -d "$asYearly"; then
                    btrfs subvolume delete "$current"
                else
                    mv "$current" "$asYearly"
                fi
            done
        '';

        serviceConfig = {
            Type = "oneshot";
            User = "root";
        };
    };
}
