{ lib, conf, ... }:

{
    networking = {
        hostName = conf.hostName;
        useDHCP = lib.mkDefault true;

        networkmanager = {
            enable = true;

            wifi = {
                macAddress = "random";
            };

            settings = {
                connection."autoconnect-retries" = 0;
            };
        };
    };
}
