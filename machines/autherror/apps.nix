{ inputs, pkgs, conf, ... }:

{
    documentation.man.generateCaches = false;

    programs = {
        fish.enable = true;
        localsend.enable = true;

        hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            xwayland.enable = true;
        };
    };
} 
