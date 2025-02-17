{ pkgs, ... }:

let
    app = "spotify";
    configDir = ./config/${app};
in {
    home.packages = [
        pkgs.${app}
    ];

    xdg.desktopEntries."spotify" = {
        name = "Spotify";
        genericName = "Music Player";

        icon = "spotify-client";

        type = "Application";
        terminal = false;

        mimeType = [ "x-scheme-handler/spotify" ];
        categories = [
            "Audio"
            "Music"
            "Player"
            "AudioVideo"
        ];

        exec = "${pkgs.spotify}/bin/spotify --enable-features=UseOzonePlatform --ozone-platform=wayland %U";

        settings = {
            StartupWMClass = "spotify";
        };
    };
}
