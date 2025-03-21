{ inputs, lib, conf, ... }:

{
    imports = lib.optionals(conf.platform == "x86_64-linux") [
        inputs.lix.nixosModules.default
    ];
}
