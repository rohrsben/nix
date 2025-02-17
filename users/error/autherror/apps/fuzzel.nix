{ ... }:

let
    app = "fuzzel";
    configDir = ./config/${app};
in {
    programs.fuzzel = {
        enable = true;
    };

    xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    };
}
