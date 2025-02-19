{ pkgs, conf, config, inputs, lib, ... }:

lib.optionalAttrs(conf.hostName == "autherror") {
    sops.secrets.error-pass.neededForUsers = true;

    users.users.error = {
        isNormalUser = true;
        shell = pkgs.fish;
        initialPassword = "password";
        hashedPasswordFile = config.sops.secrets.error-pass.path;
        extraGroups = [
            "wheel"
            "networkmanager"
            "keys"
            "dialout"
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
            ../shared/apps/nix-index.nix
            ../shared/apps/neovim
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
                lazygit
                ripgrep
                sops
                libsForQt5.qt5.qtwayland
                qt6.qtwayland
                libnotify
                xdg-utils
                python3
                lua
                pass
                p7zip
                gnused

                # command line
                typst
                gh
                pandoc
                ttyper
                cargo
                rustc
                playerctl
                wev
                imagemagick
                tdf
                age
                rsync
                btop
                grim
                slurp
                hyprpicker
                sshfs

                # graphical
                thunderbird
                mpv
                pavucontrol
                kdePackages.okular
                telegram-desktop
                foliate
                dolphin-emu
                localsend

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
