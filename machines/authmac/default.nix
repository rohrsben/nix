{ inputs, pkgs, ... }:

{
    imports = [
        ../shared/hm.nix
        ../shared/nix-config.nix
        ../shared/fonts.nix
    ] ++ [
        ../../users/error/authmac
    ];

    environment.systemPackages = [
        pkgs.kitty
    ];
}
