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

        hyprland.url = "github:hyprwm/hyprland";
        hyprlock.url = "github:hyprwm/hyprlock";
        hypridle.url = "github:hyprwm/hypridle";
        hyprshutdown.url = "github:hyprwm/hyprshutdown";
        hyprland-contrib = {
            url = "github:hyprwm/contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprsplit =  {
            url = "github:shezdy/hyprsplit";
            inputs.hyprland.follows = "hyprland";
        };

        idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";

        sops-nix = {
            url = "github:Mic92/sops-nix/a4c33bfecb93458d90f9eb26f1cf695b47285243";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

        awww.url = "git+https://codeberg.org/LGFae/awww";

        textfox.url = "github:adriankarlen/textfox";
        grub2-themes.url = "github:vinceliuice/grub2-themes";
    };

    outputs = { self, ... } @inputs:
        let
            hosts = {
                reinstall = {
                    hostName = "reinstall";
                    platform = "x86_64-linux";
                    stateVer = "24.11";
                };

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
                "reinstall" = mkNixosHost hosts.reinstall;
            };
        };
}
