{ ... }:

{
    imports = [
        ./services

        ./apps.nix
        ./audio.nix
        ./bluetooth.nix
        ./boot.nix
        ./fonts.nix
        ./graphics.nix
        ./hm.nix
        ./lix.nix
        ./locale.nix
        ./networking.nix
        ./nix-config.nix
        ./security.nix
        ./sops.nix
        ./ssh.nix
        ./storage.nix
        ./virtualization.nix
    ] ++ [
        ../../users/error/autherror
    ];

    users.mutableUsers = false;
}
