{
  den.aspects.chrony = {
    nixos = {
      services.chrony = {
        enable = true;
        enableNTS = true;
        servers = [
          "time.google.com"
          "time.cloudflare.com"
          "ohio.time.system76.com"
          "oregon.time.system76.com"
          "virginia.time.system76.com"
        ];
        extraConfig = ''
          makestep 1 -1
        '';
      };
    };
  };
}
