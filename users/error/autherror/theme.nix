{ inputs, pkgs, ... }:

let
    gtk = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.gtk;
    icon = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.icon;
    qt = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.qt;
in {
    home.packages = [
        pkgs.kdePackages.qtstyleplugin-kvantum
        pkgs.kdePackages.qt6ct

        pkgs.kdePackages.breeze-icons
        pkgs.kdePackages.qtsvg
    ];

    gtk = {
        enable = true;

        theme = {
            package = gtk;
            name = "Everforest-Red-Dark-Medium";
        };

        iconTheme = {
            package = icon;
            name = "Everforest-Dark";
        };
    };

    # qt theming
    xdg.configFile = {
        "Kvantum/MateriaEverforestDark" = {
            source = "${qt}/share/Kvantum/MateriaEverforestDark";
            recursive = true;
        };
        "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=MateriaEverforestDark";
    };

    home.pointerCursor = {
        gtk.enable = true;

        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
    };
}
