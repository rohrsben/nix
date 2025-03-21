{ inputs, pkgs, conf, lib, ... }:

{
    users.users.error = {
        home = "/Users/error";
        description = "error";
    };

    home-manager.users.error = {
        programs.home-manager.enable = true;

        imports = [
            ../shared/git.nix

            ../shared/apps/fish.nix
            ../shared/apps/fzf.nix
            ../shared/apps/kitty
            ../shared/apps/neovim
            ../shared/apps/typst
            ../shared/apps/yazi.nix
            ../shared/apps/zoxide.nix
        ];

        home = {
            username = "error";
            homeDirectory = "/Users/error";
            stateVersion = "24.05";

            packages = with pkgs; [
                bat
                eza
                fd
                gh
                pandoc
                sshfs
                
            ];
        };
    };
}
