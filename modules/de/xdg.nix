{
  den.aspects.xdg = {
    nixos = {
      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
    };

    homeManager = { pkgs, config, ... }:
      let
        xdg = "${config.home.homeDirectory}/xdg";
        desktop = "${xdg}/desktop";
        documents = "${xdg}/documents";
        download = "${config.home.homeDirectory}/downloads";
        music = "${xdg}/music";
        pictures = "${xdg}/pictures";
        projects = "${xdg}/projects";
        publicShare = "${xdg}/public";
        templates = "${xdg}/templates";
        videos = "${xdg}/videos";
      in {
        xdg = {
          enable = true;

          # TODO why is this here?
          portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
            config.common = {
              default = [ "hyprland" ];
              "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            };
          };
          userDirs = {
            enable = true;
            createDirectories = true;

            inherit desktop documents download music pictures videos projects templates publicShare;
          };
        };

        systemd.user.sessionVariables = {
          XDG_DESKTOP_DIR = "${desktop}";
          XDG_DOCUMENTS_DIR = "${documents}";
          XDG_DOWNLOAD_DIR = "${download}";
          XDG_MUSIC_DIR = "${music}";
          XDG_PICTURES_DIR = "${pictures}";
          XDG_PROJECTS_DIR = "${projects}";
          XDG_PUBLICSHARE_DIR = "${publicShare}";
          XDG_TEMPLATES_DIR = "${templates}";
          XDG_VIDEOS_DIR = "${videos}";
        };
      };
  };
}
