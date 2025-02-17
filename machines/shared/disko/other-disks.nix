{ config, lib, pkgs, modulesPath, ... }:

{
    fileSystems."/mnt/lts" = {
        device = "/dev/disk/by-label/lts";
        fsType = "btrfs";
        options = [
            "compress"
            "noatime"
        ];
    };

    swapDevices = [ ];
}
