{ inputs, ... }: {
  den.aspects.simples = {
    nixos = {
      programs.ssh.startAgent = true;
    };

    homeManager = { host, pkgs, ...}: {
      programs = {
        zoxide.enable = true;
        fzf.enable = true;
      };

      home.packages = with pkgs; [
        # tui
        btop
        lazygit
        tdf
        zellij

        # command line
        age
        bat
        cargo
        eza
        fd
        gh
        glow
        grim
        hyprpicker
        imagemagick
        nh
        p7zip
        pandoc
        pass
        playerctl
        python3
        ripgrep
        rsync
        rustc
        slurp
        sshfs
        typst
        wev
        xdg-utils
        devenv

        # graphical
        anki
        discord-canary
        foliate
        kdePackages.okular
        mpv
        pavucontrol
        telegram-desktop

        # supporting / desktop environment
        feh
        kdePackages.qtwayland
        libnotify
        # qt5.qtwayland # TODO check if this is needed
        lua
        runapp
        solaar
        sops
        udiskie
        wl-clipboard
      ];
    };
  };
}
