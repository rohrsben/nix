{ den, inputs, lib, ... }: {
  # ensure necessary flake inputs exist
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];
  flake-file.inputs = {
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  # register machine+user entities
  den.hosts.x86_64-linux.autherror = {
    users.error = { };
  };

  # defaults
  den.default = {
    includes = [
      den.batteries.hostname
      den.aspects.sops
    ];

    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";
  };

  # schemas
  den.schema = {
    user = {
      includes = [
        den.batteries.define-user
      ];

      classes = lib.mkDefault [ "homeManager" ];
    };
  };
}
