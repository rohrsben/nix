{
  den.aspects.nix-config = {
    nixos = { host, pkgs, ... }: {
      nix = {
        package = pkgs.lixPackageSets.latest.lix;
        settings.experimental-features = [ "nix-command" "flakes" ];
        gc = {
          automatic = true;
          options = "--delete-older-than 14d";
        };
        optimise.automatic = true;
      };

      nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = host.system;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        # TODO switch to backupCommand with a custom script
        backupFileExtension = "hm-backup";

        # TODO is this necessary?
        # extraSpecialArgs = { inherit inputs };
      };
    };
  };
}
