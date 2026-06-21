{
  den.aspects.nvidia = {
    nixos = { config, ... }: {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          open = true;
          package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
      };
    };
  };
}
