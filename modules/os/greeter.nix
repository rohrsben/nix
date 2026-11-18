{
  den.aspects.greeter = {
    nixos = {
      services.displayManager.noctalia-greeter = {
        enable = true;
        # settings = {
        #
        # };
      };
    };
  };
}
