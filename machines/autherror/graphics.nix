{ config, pkgs, inputs, ... }:

{
    services.xserver.videoDrivers = [
        "nvidia"
    ];

    hardware = {
        # setting this is potentially unnecessary
        graphics = {
            enable = true;
            enable32Bit = true;
        };

        nvidia = {
            modesetting.enable = true;
            powerManagement = {
                enable = false;
                finegrained = false;
            };

            package = config.boot.kernelPackages.nvidiaPackages.beta;
            open = true;
            nvidiaSettings = false;
        };
    };
}
