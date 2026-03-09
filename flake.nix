{
    description = "autherror system config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        personal = {
            url = "github:rohrsben/personal-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprsplit.url = "github:shezdy/hyprsplit?ref=v0.54.1";
        awww.url = "git+https://codeberg.org/LGFae/awww";

        idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
        neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
        textfox.url = "github:adriankarlen/textfox";
    };

    outputs = { self, ... } @inputs:
        let
            hosts = {
                desktop = {
                    hostName = "autherror";
                    platform = "x86_64-linux";
                    stateVer = "24.11";
                };
            };

            mkNixosHost = { hostName, platform, stateVer }@conf: inputs.nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs conf; };

                modules = [
                    inputs.home-manager.nixosModules.home-manager
                    ./machines/${hostName}
                ];
            };

        in {
            nixosConfigurations = {
                "autherror" = mkNixosHost hosts.desktop;
            };
        };
}
