{ inputs, pkgs, config, ... }:

let
    app = "hypr";
    configDir = ./config;
    mainMonitor = "DP-3";
    secondaryMonitor = "DP-1";
    hyprsplit = inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit;
in {
    home.packages = [
        pkgs.grimblast
        pkgs.hypridle
        pkgs.hyprlock
        pkgs.hyprpolkitagent
        pkgs.hyprshutdown
        inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
        inputs.idle-inhibit.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    };

    wayland.windowManager.hyprland = {
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        enable = true;
        plugins = [ hyprsplit ];
        settings = {
            env = [
                "LIBVA_DRIVER_NAME,nvidia"
                "__GLX_VENDOR_LIBRARY_NAME,nvidia"
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "QT_QPA_PLATFORM,wayland"
                "QT_QPA_PLATFORMTHEME,qt6ct"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            ];
            monitor = [
                ", preferred, auto, auto"
                "${mainMonitor}, 2560x1440@144, 0x0, 1"
                "${secondaryMonitor}, 2560x1440@144, 2560x-745, 1, transform, 3"
            ];
            exec-once = [
                "waybar "
                "udiskie --tray"
                "hypridle"
                "hyprctl dispatch workspace 6"
                "wayland-pipewire-idle-inhibit"
                "systemctl --user start hyprpolkitagent"
            ];
            windowrule = [
                "match:class (firefox), match:title (Library), float on, center on, size 1000 800"
            ];
            plugin.hyprsplit = {
                num_workspaces = "5";
                persistent_workspaces = "true";
            };
            input = {
                kb_layout = "us";
                follow_mouse = "1";
                sensitivity = "-0.7";
                numlock_by_default = "true";
                repeat_delay = "300";
            };
            cursor = {
                use_cpu_buffer = "1";
            };
            misc = {
                disable_hyprland_logo = "true";
                font_family = "JetBrainsMono Nerd Font";
            };
            general = {
                gaps_in = "6";
                gaps_out = "12";
                border_size = "2";
                layout = "dwindle";
                allow_tearing = "false";
                "col.active_border" = "rgba(5c845fff)";
                "col.inactive_border" = "rgba(B3B3B3FF)";
            };
            decoration = {
                rounding = "6";
                shadow.enabled = "false";
            };
            group = {
                merge_groups_on_drag = "false";
                "col.border_active" = "rgb(5C845F)";
                "col.border_inactive" = "rgb(B3B3B3)";
                "col.border_locked_active" = "rgb(C67B6C)";
                "col.border_locked_inactive" = "rgb(B3B3B3)";
                groupbar = {
                    font_family = "JetBrainsMono Nerd Font";
                    font_size = "12";
                    text_color = "rgb(000000)";
                    height = "18";
                    gradients = "true";
                    gradient_rounding = "6";
                    indicator_height = "0";
                    "col.active" = "rgb(5C845F)";
                    "col.inactive" = "rgba(d1d0c780)";
                    "col.locked_active" = "rgb(C67B6C)";
                    "col.locked_inactive" = "rgba(c67b6c80)";
                };
            };
            animations = {
                enabled = "true";
                bezier = "myBezier, 0.02, 0.14, 0.51, 0.97";
                animation = [
                    "workspaces, 1, 3, myBezier, slidevert"
                    "windows, 0"
                    "layers, 0"
                    "fade, 0"
                    "border, 0"
                    "borderangle, 0"
                    "zoomFactor, 0"
                    "monitorAdded, 0"
                ];
            };
            dwindle = {
                pseudotile = "true";
                preserve_split = "true";
            };
            bind = [
                "SUPER, Return, exec, kitty"
                "SUPER, Q, killactive,"
                "SUPER SHIFT, M, exec, hyprshutdown"
                "SUPER SHIFT, F, togglefloating,"
                "SUPER, code:65, exec, tofi-drun --drun-launch=true"
                "SUPER, J, togglesplit, # dwindle"
                "SUPER, P, exec, ~/.scripts/powermenu.sh"
                "SUPER, G, togglegroup"
                "SUPER SHIFT, G, lockactivegroup, toggle"
                "SUPER, R, moveoutofgroup"
                "SUPER, Tab, changegroupactive"
                "SUPER, F, fullscreen"
                "SUPER, L, exec, hyprlock"
                "SUPER, left, movefocus, l"
                "SUPER, right, movefocus, r"
                "SUPER, up, movefocus, u"
                "SUPER, down, movefocus, d"
                "SUPER, 1, split:workspace, 1"
                "SUPER, 2, split:workspace, 2"
                "SUPER, 3, split:workspace, 3"
                "SUPER, 4, split:workspace, 4"
                "SUPER, 5, split:workspace, 5"
                "SUPER SHIFT, 1, split:movetoworkspace, 1"
                "SUPER SHIFT, 2, split:movetoworkspace, 2"
                "SUPER SHIFT, 3, split:movetoworkspace, 3"
                "SUPER SHIFT, 4, split:movetoworkspace, 4"
                "SUPER SHIFT, 5, split:movetoworkspace, 5"
                "SUPER, S, togglespecialworkspace, magic"
                "SUPER SHIFT, S, split:movetoworkspace, special:magic"
                ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ",XF86AudioPlay, exec, playerctl play"
                ",XF86AudioPause, exec, playerctl pause"
                ",code:172, exec, playerctl play-pause"
                ",XF86AudioPrev, exec, playerctl previous"
                ",XF86AudioNext, exec, playerctl next"
                "Shift, Print, exec, grimblast --notify --freeze save area ${config.xdg.userDirs.pictures}/screenshots/$(date +'%b%d-%T.png')"
                ",Print, exec, grimblast --notify save area ${config.xdg.userDirs.pictures}/screenshots/$(date +'%b%d-%T.png')"
            ];
            bindm = [
                "SUPER, mouse:272, movewindow"
                "SUPER, mouse:273, resizewindow"
            ];
            binde = [
                ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
                ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+"
            ];
        };
    };

    home.file.".scripts/powermenu.sh" = {
        executable = true;
        text = ''
            #!/usr/bin/env fish

            set options "Restart
            Power off"

            set result (echo $options | tofi --prompt-text="" --width=290 --height=180 --padding-top=0 --padding-bottom=0 --padding-left=50 --padding-right=0)

            if test -n "$result"
                if test "$result" = "Restart"
                    systemctl stop tailscaled.service && systemctl reboot
                else if test "$result" = "Power off"
                    systemctl stop tailscaled.service && systemctl poweroff
                end
            end
        '';
    };
}
