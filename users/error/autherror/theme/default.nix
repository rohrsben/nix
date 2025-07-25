{ pkgs, ... }:

let
    colloid-gtk = import ./colloid-gtk.nix { inherit pkgs; };
    colloid-icon = import ./colloid-icon.nix { inherit pkgs; };
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
