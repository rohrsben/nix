{ inputs, pkgs, ... }:

let
    hyprsplit = inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplitlua;
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

    xdg.configFile."hypr" = {
        source = ./config;
        recursive = true;
    };

    xdg.configFile."hypr/hyprsplit" = {
        source = "${hyprsplit}/share/hyprsplit";
        recursive = true;
    };

    # hyprland uwsm recommendation
    xdg.configFile."uwsm/env".text = ''
        export LIBVA_DRIVER_NAME=nvidia
        export QT_QPA_PLATFORM=wayland
        export QT_QPA_PLATFORMTHEME=qt6ct
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';

    wayland.windowManager.hyprland = {
        configType = "lua"; # state version
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        systemd.enable = false; # for uwsm
        enable = true;
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
                    systemctl reboot
                else if test "$result" = "Power off"
                    systemctl poweroff
                end
            end
        '';
    };
}
