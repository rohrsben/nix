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

        ./services

        ./apps.nix
        ./audio.nix
        ./bluetooth.nix
        ./fonts.nix
        ./graphics.nix
        ./security.nix
        ./sops.nix
        ./ssh.nix
    ] ++ [
        ../../users/error
    ];

    users.mutableUsers = false;
}
