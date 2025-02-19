{ inputs, pkgs, ... }:

let
    app = "hypr";
    configDir = ./config/;
    mainMonitor = "DP-3";
    secondaryMonitor = "DP-1";
    xdgpics = "/home/error/xdg/pictures";
in {
    home.packages = [
        inputs.hyprlock.packages.${pkgs.system}.default
        inputs.hypridle.packages.${pkgs.system}.default
        inputs.hyprland-contrib.packages.${pkgs.system}.grimblast; 
        inputs.swww.packages.${pkgs.system}.swww
        pkgs.jq
    ];

    home.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    xdg.configFile."uwsm/env" = {
        text = ''
            export LIBVA_DRIVER_NAME=nvidia
            export GBM_BACKEND=nvidia-drm
            export __GLX_VENDOR_LIBRARY_NAME=nvidia

            export SDL_VIDEODRIVER=wayland
            export QT_QPA_PLATFORM=wayland

            export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        '';
    };

    xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    };

    # TODO hyprpolkit agent

    wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        plugins = [ 
            inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
        ];

        extraConfig = ''
            # See https://wiki.hyprland.org/Configuring/Monitors/
            monitor=,preferred,auto,auto
            monitor = ${mainMonitor}, 2560x1440@144, 0x0, 1
            monitor = ${secondaryMonitor}, 2560x1440@144, 2560x-745, 1, transform, 3

            exec-once = uwsm app -- waybar 
            exec-once = uwsm app -- udiskie --tray
            exec-once = systemctl --user enable --now hypridle.service

            windowrulev2 = float, class:(firefox), title:(Library)
            windowrulev2 = size 1000 800, class:(firefox), title:(Library)
            windowrulev2 = center 1, class:(firefox), title:(Library)

            plugin {
                hyprsplit {
                    num_workspaces = 5
                    persistent_workspaces = true
                }
            }

            input {
                kb_layout = us

                follow_mouse = 1

                # for mouse
                sensitivity = -0.7

                numlock_by_default = true
            }

            cursor {
                use_cpu_buffer = 1
            }

            misc {
                new_window_takes_over_fullscreen = 2
                disable_hyprland_logo = true
            }

            general {
                gaps_in = 6
                gaps_out = 12
                border_size = 2
                col.active_border = rgba(5C845FFF)
                col.inactive_border = rgba(B3B3B3FF)
                layout = dwindle

                allow_tearing = false
            }

            decoration {
                rounding = 6

                blur {
                    enabled = true
                    size = 3
                    passes = 1
                }

                shadow {
                    enabled = false
                }
            }

            group {
                merge_groups_on_drag = false
                col.border_active = rgb(5C845F)
                col.border_inactive = rgb(B3B3B3)
                col.border_locked_active = rgb(C67B6C)
                col.border_locked_inactive = rgb(B3B3B3)
                groupbar {
                    font_family = JetBrainsMono Nerd Font
                    font_size = 12
                    text_color = rgb(000000)
                    height = 18
                    gradients = true
                    gradient_rounding = 6
                    indicator_height = 0
                    col.active = rgb(5C845F)
                    col.inactive = rgba(d1d0c780)
                    col.locked_active = rgb(C67B6C)
                    col.locked_inactive = rgba(c67b6c80)
                }
            }

            layerrule = noanim, launcher

            animations {
                enabled = true

                bezier = myBezier, 0.02, 0.14, 0.51, 0.97

                animation = windowsIn, 1, 3, myBezier, slide
                animation = windowsOut, 1, 3, myBezier, popin
                animation = windowsMove, 1, 3, myBezier, slide
                animation = border, 1, 10, default
                animation = fade, 1, 7, default
                animation = workspaces, 1, 4, myBezier, slidevert
            }

            dwindle {
                pseudotile = true 
                preserve_split = true 
            }

            $mainMod = SUPER

            bind = $mainMod, Return, exec, uwsm app -- kitty
            bind = $mainMod, Q, killactive,
            bind = $mainMod, M, exec, uwsm stop
            bind = $mainMod, V, togglefloating,
            bind = $mainMod, code:65, exec, fuzzel
            bind = $mainMod, J, togglesplit, # dwindle

            bind = $mainMod, G, togglegroup
            bind = $mainMod SHIFT, G, lockactivegroup, toggle
            bind = $mainMod, R, moveoutofgroup
            bind = $mainMod, Tab, changegroupactive

            bind = $mainMod, F, fullscreen

            bind = $mainMod, left, movefocus, l
            bind = $mainMod, right, movefocus, r
            bind = $mainMod, up, movefocus, u
            bind = $mainMod, down, movefocus, d

            bind = $mainMod, 1, split:workspace, 1
            bind = $mainMod, 2, split:workspace, 2
            bind = $mainMod, 3, split:workspace, 3
            bind = $mainMod, 4, split:workspace, 4
            bind = $mainMod, 5, split:workspace, 5

            bind = $mainMod SHIFT, 1, split:movetoworkspace, 1
            bind = $mainMod SHIFT, 2, split:movetoworkspace, 2
            bind = $mainMod SHIFT, 3, split:movetoworkspace, 3
            bind = $mainMod SHIFT, 4, split:movetoworkspace, 4
            bind = $mainMod SHIFT, 5, split:movetoworkspace, 5

            bind = $mainMod, S, togglespecialworkspace, magic
            bind = $mainMod SHIFT, S, split:movetoworkspace, special:magic

            bindm = $mainMod, mouse:272, movewindow
            bindm = $mainMod, mouse:273, resizewindow

            binde = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
            binde = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+
            bind = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bind = ,XF86AudioPlay, exec, playerctl play
            bind = ,XF86AudioPause, exec, playerctl pause
            bind = ,code:172, exec, playerctl play-pause
            bind = ,XF86AudioPrev, exec, playerctl previous
            bind = ,XF86AudioNext, exec, playerctl next

            bind = Shift,Print, exec, grimblast --notify --freeze save area ${xdgpics}/screenshots/$(date +'%b%d-%T.png')
            bind = ,Print, exec, grimblast --notify save area ${xdgpics}/screenshots/$(date +'%b%d-%T.png')
        '';
    };
}
