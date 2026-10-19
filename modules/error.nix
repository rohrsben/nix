{ den, ... }: {
  den.aspects.error = {
    includes = with den.aspects; [
      # programs
      calibre
      firefox
      fish
      git
      greetd
      kitty
      localsend
      neovim
      niri
      nix-index
      noctalia
      simples
      spotify
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
