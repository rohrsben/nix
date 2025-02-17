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
        ../../users/error
    ];

    programs.fish.enable = true;
}
