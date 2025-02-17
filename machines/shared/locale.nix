{ ... }:

{
    time.timeZone = "America/New_York";
    services.chrony = {
        enable = true;
        enableNTS = true;
        servers = [ 
            "time.cloudflare.com"
            "ohio.time.system76.com"
            "oregon.time.system76.com"
            "virginia.time.system76.com"
        ];
        extraConfig = ''
            makestep 1 -1
        '';
    };

    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
        };
    };
}
