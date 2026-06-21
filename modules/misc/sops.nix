{ inputs, ... }: {
  flake-file.inputs.sops-nix = {
    url = "github:mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # this aspect is included by default
  den.aspects.sops = {
    nixos = { host, ... }: {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/host_${host.name}.yaml;
        validateSopsFiles = false;
        age = {
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
      };
    };

    homeManager = { config, user, ... }: {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/user_${user.userName}.yaml;
        age = {
          sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/identity" ];
          keyFile = "${config.home.homeDirectory}/.local/state/sops/key.txt";
          generateKey = true;
        };
      };
    };
  };
}
