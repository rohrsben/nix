{ inputs, pkgs, config, ... }:

let
    awwwDaemon = "${inputs.awww.packages.${pkgs.system}.awww}/bin/awww-daemon";
    backgrounds = "/home/error/nix/users/error/hm/apps/config/outofstore/backgrounds/";
in {
    systemd.user.services.awwwDaemon = {
        Unit = {
            Description = "Awww Daemon";
            After = "graphical-session.target";
            BindsTo = "graphical-session.target";
            PartOf = "graphical-session.target";
        };

        Service = {
            Type = "exec";
            ExecStart = "${awwwDaemon}";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };

    programs.fish.functions.aw-set = {
        body = ''
            argparse 'd' 'l' 'p' 's' -- $argv

            set PRIMARY DP_3
            set SECONDARY DP_1

            set search_dir ${config.xdg.userDirs.pictures}/backgrounds

            if not set -ql _flag_d
                if not set -ql _flag_s
                    if not set -ql _flag_p
                        if not set -ql _flag_d
                            echo "USAGE"
                            echo " -d: set default backgrounds"
                            echo " -l: search for images in the current dir (otherwise, use ${config.xdg.userDirs.pictures}/backgrounds)"
                            echo " -p: change the background of the primary monitor"
                            echo " -s: change the background of the secondary monitor"
                        end
                    end
                end
            end

            if set -ql _flag_d
                echo "Setting default backgrounds."
                awww img -o (echo $PRIMARY | sed -e 's/_/-/g') --transition-fps 120 $search_dir/primary.*
                awww img -o (echo $SECONDARY | sed -e 's/_/-/g') --transition-fps 120 $search_dir/secondary.*
                return 0
            end

            if set -ql _flag_l
                set search_dir .
            end

            if set -ql _flag_p
                set -a to_change PRIMARY
            end

            if set -ql _flag_s
                set -a to_change SECONDARY
            end

            for monitor in $to_change
                set $$monitor (fd -e png -e jpg --base-directory $search_dir | fzf --prompt "$monitor > " --height 30% --min-height 15 --preview "kitten icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place=\"\$FZF_PREVIEW_COLUMNS\"x\"\$FZF_PREVIEW_LINES\"@0x0 $search_dir/{}")
            end

            for monitor in $to_change
                if test -n "$$$monitor"
                    awww img -o (echo $$monitor | sed -e 's/_/-/g' ) -t any --transition-fps 120 $search_dir/$$$monitor
                end
            end
        '';
    };
}
