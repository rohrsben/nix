{ lib, conf, ... }:

{
    nixpkgs.config.allowUnfree = true;

    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
            substituters = [ "https://hyprland.cachix.org" ];
            trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
        };

        gc = {
            automatic = true;
            options = "--delete-older-than 14d";
        };

        optimise = {
            automatic = true;
        };
    };

    nixpkgs.hostPlatform = conf.platform;
    system.stateVersion = conf.stateVer;
}
