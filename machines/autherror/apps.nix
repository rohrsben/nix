{ inputs, pkgs, conf, ... }:

{
    programs.fish.enable = true;
    documentation.man.generateCaches = false;

    programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland.enable = true;
        withUWSM = true;
    };
} 
