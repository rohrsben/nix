{
  den.aspects.spotify = {
    nixos = {
      # TODO a/b test these
      networking.firewall = {
        allowedUDPPorts = [ 5353 57261 ];
        allowedTCPPorts = [ 4070 57261 ];
      };
    };

    homeManager = { pkgs, lib, ... }: {
      home.packages = [ pkgs.spotify ];

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
        exec = "${lib.getExe pkgs.spotify} --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
        settings.StartupWMClass = "spotify";
      };
    };
  };
}
