{ ... }:

{
    imports = [
        ../shared/disko
        ../shared/boot.nix
        ../shared/hm.nix
        ../shared/lix.nix
        ../shared/locale.nix
        ../shared/networking.nix
        ../shared/nix-config.nix
    ] ++ [
        ../../users/error/minimal
    ];

    programs.fish.enable = true;
}
