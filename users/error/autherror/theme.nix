{ inputs, pkgs, ... }:

let
    colloid-gtk = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.colloid-gtk;
    colloid-icon = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.colloid-icon;
in {
    gtk = {
        enable = true;

        theme = {
            package = colloid-gtk;
            name = "Colloid-Red-Dark-Everforest";
        };

        iconTheme = {
            package = colloid-icon;
            name = "Colloid-Everforest-Dark";
        };
    };

    qt = {
        enable = true;
    };

    home.pointerCursor = {
        gtk.enable = true;

        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
    };
}
