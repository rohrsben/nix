{ inputs, lib, conf, ... }:

{
    imports = [
        inputs.disko.nixosModules.disko
    ] ++ lib.optionals(conf.hostName == "minimal") [
        ./autherror.nix
        ./other-disks.nix
    ] ++ lib.optionals(conf.hostName == "autherror") [
        ./autherror.nix
        ./other-disks.nix
    ];
}
