{ lib, pkgs, conf, config, ... }:

lib.optionalAttrs(conf.hostName == "autherror") {
    sops.secrets.error-pass.neededForUsers = true;

    users.users.error = {
        isNormalUser = true;
        shell = pkgs.fish;
        initialPassword = "password";
        hashedPasswordFile = config.sops.secrets.error-pass.path;
        extraGroups = [
            "dialout"
            "keys"
            "networkmanager"
            "wheel"
        ];
    };

    home-manager.users.error = {
        programs.home-manager.enable = true;

        imports = [ 
            ./apps

            ./sops.nix
            ./theme.nix
            ./xdg.nix

            ../shared/git.nix

            ../shared/apps/fish.nix
            ../shared/apps/fzf.nix
            ../shared/apps/kitty
            ../shared/apps/neovim
            ../shared/apps/nix-index.nix
            ../shared/apps/typst
            ../shared/apps/yazi.nix
            ../shared/apps/zoxide.nix
        ];
    };
}
