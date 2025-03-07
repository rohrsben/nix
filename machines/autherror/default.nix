{ ... }:

{
    imports = [
        ../shared/boot.nix
        ../shared/disko
        ../shared/fonts.nix
        ../shared/hm.nix
        ../shared/lix.nix
        ../shared/locale.nix
        ../shared/networking.nix
        ../shared/nix-config.nix

        ./services

        ./apps.nix
        ./audio.nix
        ./bluetooth.nix
        ./graphics.nix
        ./sops.nix
        ./ssh.nix
        ./virtualization.nix
    ] ++ [
        ../../users/error
    ];

    users.mutableUsers = false;
}
