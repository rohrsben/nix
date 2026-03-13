{ lib, pkgs, conf, config, ... }:

{
    sops.secrets.error-pass.neededForUsers = true;

    users.users.error = {
        isNormalUser = true;
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets.error-pass.path;
        extraGroups = [ "dialout" "keys" "networkmanager" "wheel" "libvirtd" ];
    };

    home-manager.users.error = {
        programs.home-manager.enable = true;

        imports = [ 
            ./apps

            ./git.nix
            ./sops.nix
            ./theme.nix
            ./xdg.nix
        ];
    };
}
