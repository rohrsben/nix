{ inputs, ... }: {
  flake-file.inputs.idle-inhibit = {
    url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.idle-inhibit = {
    homeManager = { host, ... }: {
      home.packages = [ inputs.idle-inhibit.packages.${host.system}.default ];
    };
  };
}
