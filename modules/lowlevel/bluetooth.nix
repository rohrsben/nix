{
  den.aspects.bluetooth = {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        settings = {
          General = {
            DiscoverableTimeout = 30;
            FastConnectable = true;
          };
        };
      };
    };
  };
}
