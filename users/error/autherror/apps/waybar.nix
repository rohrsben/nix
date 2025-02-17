{ pkgs, inputs, ... }:

let
    app = "waybar";
    configDir = ./config/${app};
in {
    home.packages = [
        pkgs.${app}
    ];

    xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    };
}
