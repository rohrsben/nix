{ inputs, pkgs, conf, ... }:

{
    imports = [
        ./hypr
        ./kitty
        ./mako
        ./neovim
        ./tofi
        ./waybar

        ./awww.nix
        ./firefox.nix
        ./fish.nix
        ./spotify.nix
        ./yazi.nix

        inputs.nix-index-database.homeModules.nix-index
    ];

    programs = {
        zoxide.enable = true;
        nix-index-database.comma.enable = true;
        fzf.enable = true;
        direnv = {
            enable = true;
            nix-direnv.enable = true;
        };
    };

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
            kdePackages.qtwayland
            lazygit
            libnotify
            libsForQt5.qt5.qtwayland
            lua
            p7zip
            pass
            python3
            ripgrep
            sops
            xdg-utils

            # command line
            age
            btop
            cargo
            devenv
            gh
            glow
            grim
            hyprpicker
            imagemagick
            nh
            pandoc
            playerctl
            rsync
            rustc
            slurp
            sshfs
            tdf
            ttyper
            typst
            wev
            zellij

            # graphical
            anki
            calibre
            foliate
            kdePackages.okular
            mpv
            pavucontrol
            telegram-desktop
            thunderbird
            discord-canary

            # supporting / desktop environment
            feh
            solaar
            udiskie
            wl-clipboard
        ];
    };
}
