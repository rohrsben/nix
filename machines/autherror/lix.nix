{ inputs, ... }:

{
    imports = [
        inputs.lix.nixosModules.default
    ];
}
