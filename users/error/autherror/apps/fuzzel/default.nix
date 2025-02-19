{ ... }:

let
    app = "fuzzel";
    configDir = ./config;
in {
    programs.fuzzel = {
        enable = true;
    };

    xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    };
}
