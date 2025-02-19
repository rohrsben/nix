{ pkgs, ... }:

let
    app = "typst";
    configDir = ./config;
in {
    home.packages = [
        pkgs.${app}
    ];

    home.file.".local/share/typst/packages/local" = {
        source = "${configDir}";
        recursive = true;
    };
}
