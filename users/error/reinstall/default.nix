{ inputs, pkgs, conf, lib, ... }:

{
    users.users.error = {
        isNormalUser = true;
        shell = pkgs.fish;
        initialPassword = "password";
        extraGroups = [ "wheel" "networkmanager" ];
    };

    security.sudo.wheelNeedsPassword = false;

    home-manager.users.error = {
        programs.home-manager.enable = true;

        imports = [
            ../shared/git.nix

            ../shared/apps/fish.nix
            ../shared/apps/fzf.nix
            ../shared/apps/nix-index.nix
            ../shared/apps/neovim
            ../shared/apps/yazi.nix
            ../shared/apps/zoxide.nix
        ];

        home = {
            username = "error";
            homeDirectory = "/home/error";
            stateVersion = "${conf.stateVer}";

            packages = with pkgs; [
                bat
                coreutils
                eza
                fd
                lazygit
                ripgrep
                sops
            ] ++ [
                inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            file."run-me.sh" = {
                executable = true;

                text = ''
                    #!/usr/bin/env bash

                    nmtui

                    if [ ! -f /mnt/lts/backups/keys/host ]; then
                        echo "No host key in backups/keys. Please place one there under the name 'host'."
                        exit
                    fi

                    if [ ! -f /mnt/lts/backups/keys/host.pub ]; then
                        echo "No host public key in backups/keys. Please place one there under the name 'host.pub'."
                        exit
                    fi

                    if [ ! -f /mnt/lts/backups/keys/age ]; then
                        echo "No age key in backups/keys. Please place one there under the name 'age'."
                        exit
                    fi

                    sudo cp /mnt/lts/backups/keys/host /etc/ssh/ssh_host_ed25519_key
                    sudo cp /mnt/lts/backups/keys/host.pub /etc/ssh/ssh_host_ed25519_key.pub

                    mkdir -p .config/sops/age
                    cp /mnt/lts/backups/keys/age .config/sops/age/keys.txt

                    git clone https://github.com/rohrsben/nix
                    sed -i -e 's_https://github.com/_git@github.com:_g' nix/.git/config

                    mkdir -p xdg/pictures/backgrounds
                    cp nix/reinstall/backgrounds/* xdg/pictures/backgrounds
                    sudo nh os boot --bypass-root-check ./nix --hostname autherror && systemctl reboot
                '';
            };
        };
    };
}
