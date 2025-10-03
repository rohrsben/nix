{ inputs, pkgs, ... }:

let
    colloid-gtk = inputs.personal.packages.${pkgs.system}.colloid-gtk;
    colloid-icon = inputs.personal.packages.${pkgs.system}.colloid-icon;
in {
    gtk = {
        enable = true;

        theme = {
            package = colloid-gtk;
            name = "Colloid-Red-Dark-Everforest";
        };

        iconTheme = {
            package = colloid-icon;
            name = "Colloid-Grey-Everforest";
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
