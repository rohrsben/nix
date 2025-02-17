{ pkgs, ... }:

{
    gtk = {
        enable = true;

        theme = {
            package = pkgs.colloid-gtk-theme.override {
                themeVariants = [ "red" ];
                colorVariants = [ "dark" ];
                tweaks = [ "everforest" "rimless" "normal" ];
            };
            name = "Colloid-Red-Dark-Everforest";
        };

        iconTheme = {
            package = pkgs.colloid-icon-theme.override {
                schemeVariants = [ "everforest" ];
                colorVariants = [ "grey" ];
            };
            name = "Colloid-Grey-Everforest";
            # package = pkgs.papirus-icon-theme;
            # name = "Papirus";
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
