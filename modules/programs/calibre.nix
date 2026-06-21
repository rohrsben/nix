{
  den.aspects.calibre = {
    nixos = {
      services.gvfs.enable = true;
    };

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.calibre ];
    };
  };
}
