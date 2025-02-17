{ pkgs, ... }:

let
    xdg = "/home/error/xdg";
in {
    xdg = {
        enable = true;

        portal = {
            enable = true;
            extraPortals = [
                pkgs.xdg-desktop-portal-gtk
            ];

            config = {
                common = {
                    default = [ "hyprland" ];
                    "org.freedesktop.impl.portal.FileChooser" = [
                        "gtk"
                    ];
                };
            };
        };
        
        userDirs = {
            enable = true;

            download = "/home/error/downloads";
            desktop = "${xdg}/desktop";
            documents = "${xdg}/documents";
            videos = "${xdg}/videos";
            pictures = "${xdg}/pictures";
            music = "${xdg}/music";
        };
    };
}
