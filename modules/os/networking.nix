{
  den.aspects.networking = {
    nixos = {
      networking = {
        # maybe unnecessary
        useDHCP = false;
        dhcpcd.enable = false;

        useNetworkd = true;
        wireless.iwd = {
          enable = true;
          settings = {
            General.AddressRandomization = "network";
          };
        };
      };

      systemd.network = {
        enable = true;
        networks."10-wlan" = {
          matchConfig.Type = "wlan";
          networkConfig.DHCP = "yes";
        };
      };

      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNSOverTLS = true;
          DNS = [ "9.9.9.9" ];
          LLMNR = false;
          MulticastDNS = false;
        };
      };
    };
  };
}
