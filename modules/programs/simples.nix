{
  den.aspects.simples = {
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
        imagemagick
        nh
        p7zip
        pandoc
        pass
        python3
        ripgrep
        rsync
        rustc
        sshfs
        typst
        wev
        xdg-utils
        devenv
        helix

        # graphical
        anki-bin
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
        lua
        solaar
        sops
        udiskie
        wl-clipboard
      ];
    };
  };
}
