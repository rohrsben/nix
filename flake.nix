{
    description = "autherror system config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        lix = {
            url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        darwin = {
            url = "github:LnL7/nix-darwin/master";
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

        nh = {
            url = "github:viperML/nh";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        hyprsplit =  {
            url = "github:shezdy/hyprsplit";
            inputs.hyprland.follows = "hyprland";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix/a4c33bfecb93458d90f9eb26f1cf695b47285243";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        swww.url = "github:LGFae/swww";

        hyprlock.url = "github:hyprwm/hyprlock";
        hypridle.url = "github:hyprwm/hypridle";
        hyprland-contrib = {
            url = "github:hyprwm/contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        textfox.url = "github:adriankarlen/textfox";
        grub2-themes.url = "github:vinceliuice/grub2-themes";
    };

    outputs = { self, ... } @inputs:
        let
            hosts = {
                minimal = {
                    hostName = "minimal";
                    platform = "x86_64-linux";
                    stateVer = "24.11";
                };

                desktop = {
                    hostName = "autherror";
                    platform = "x86_64-linux";
                    stateVer = "24.11";
                };
            };

            mkNixosHost = { hostName, platform, stateVer }@conf:
                inputs.nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs conf; };

                    modules = [
                        inputs.home-manager.nixosModules.home-manager
                        ./machines/${hostName}
                    ];
                };

        in {
            nixosConfigurations = {
                "autherror" = mkNixosHost hosts.desktop;
                "minimal" = mkNixosHost hosts.minimal;
            };
        };
}
