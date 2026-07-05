{ den, ... }: {
  den.aspects.error = {
    includes = with den.aspects; [
      # programs
      awww
      calibre
      firefox
      fish
      fuzzel
      git
      greetd
      hypridle
      hyprlock
      kitty
      localsend
      mako
      neovim
      niri
      nix-index
      simples
      spotify
      waybar
      yazi

      # de
      duckypad
      everforest
      home-backup
      idle-inhibit
      mousebat
      scripts
      tailscale
      xdg
    ];

    homeManager = { config, ... }: {
      sops.secrets = {
       ssh-gh-rohrsben.path = "${config.home.homeDirectory}/.ssh/gh-rohrsben";
      };
    };

    user = { pkgs, config, ... }: {
      isNormalUser = true;
      shell = pkgs.fish;
      uid = 1000;
      hashedPasswordFile = config.sops.secrets.pass-error.path;
      extraGroups = [ "dialout" "keys" "wheel" "libvirtd" ];
    };

    nixos = {
      fileSystems."lts" = {
        label = "lts";
        mountPoint = "/home/error/lts";
        fsType = "btrfs";
        options = [ "compress" "noatime" ];
      };

      sops.secrets = {
         pass-error.neededForUsers = true;
      };
    };
  };
}
