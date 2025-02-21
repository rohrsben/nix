{ pkgs, conf, config, ... }:

{
    imports = [
        ./autherror
        ./authmac
        ./minimal
    ];
}
