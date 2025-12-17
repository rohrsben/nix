{ lib, conf, pkgs, ... }:

{
    # use lix
    nixpkgs.overlays = [ (final: prev: {
        inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena;
    }) ];
    nix.package = pkgs.lixPackageSets.stable.lix;

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

    # TODO rehome?
    nixpkgs.hostPlatform = conf.platform;
    system.stateVersion = conf.stateVer;
}
