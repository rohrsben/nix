{ ... }:

{
    imports = [
        ../autherror/boot.nix
        ../autherror/hm.nix
        ../autherror/lix.nix
        ../autherror/locale.nix
        ../autherror/networking.nix
        ../autherror/nix-config.nix
        ../autherror/storage.nix
    ] ++ [
        ../../users/error/reinstall
    ];

    programs.fish.enable = true;
}
