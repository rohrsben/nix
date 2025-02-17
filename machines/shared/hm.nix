{ inputs, conf, ... }:

{
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
            inherit inputs conf;
        };
    };
}
