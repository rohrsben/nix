{ pkgs, conf, config, inputs, lib, ... }:

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

        home = {
            username = "error";
            homeDirectory = "/home/error";
            stateVersion = "${conf.stateVer}";

            packages = with pkgs; [
                bat
                coreutils
                eza
                fd
                gnused
                lazygit
                libnotify
                libsForQt5.qt5.qtwayland
                lua
                p7zip
                pass
                python3
                kdePackages.qtwayland
                ripgrep
                sops
                xdg-utils

                # command line
                age
                btop
                cargo
                gh
                grim
                hyprpicker
                imagemagick
                pandoc
                playerctl
                rsync
                rustc
                slurp
                sshfs
                tdf
                ttyper
                wev
                zellij

                # graphical
                dolphin-emu
                foliate
                kdePackages.okular
                localsend
                mpv
                pavucontrol
                telegram-desktop
                thunderbird

                # supporting / desktop environment
                udiskie
                solaar
                wl-clipboard
                feh
            ] ++ [
                inputs.nh.packages.${pkgs.system}.default
            ];
        };
    };
}
