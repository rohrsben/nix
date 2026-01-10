{ inputs, pkgs, conf, ... }:

{
    imports = [
        ./hypr
        ./mako
        ./tofi
        ./waybar

        ./awww.nix
        ./direnv.nix
        ./discord-canary.nix
        ./firefox.nix
        ./spotify.nix
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
            gh
            glow
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
            typst
            wev
            zellij

            # graphical
            calibre
            foliate
            kdePackages.okular
            localsend
            mpv
            pavucontrol
            telegram-desktop
            thunderbird

            # supporting / desktop environment
            feh
            solaar
            udiskie
            wl-clipboard
        ] ++ [
            inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
    };
}
