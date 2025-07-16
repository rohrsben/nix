{ lib, conf, ... }:

{
    nixpkgs.config.allowUnfree = true;

    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
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
