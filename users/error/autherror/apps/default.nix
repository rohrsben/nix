{ inputs, pkgs, conf, ... }:

{
    imports = [
        ./fuzzel
        ./hypr
        ./mako
        ./waybar

        ./direnv.nix
        ./discord-canary.nix
        ./firefox.nix
        ./spotify.nix
        ./swww.nix
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
            glow

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
}
