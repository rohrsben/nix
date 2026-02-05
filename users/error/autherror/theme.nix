{ inputs, pkgs, ... }:

let
    gtk = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.gtk;
    icon = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.icon;
in {
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
