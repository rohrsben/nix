{ pkgs, ... }:

let
    app = "mako";
    configDir = ./config;
in {
    home.packages = [
        pkgs.${app}
    ];

   xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    }; 
}
