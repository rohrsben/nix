{
  den.aspects.udisks2 = {
    nixos = {
      services.udisks2 = {
        enable = true;
        mountOnMedia = true;
      };
    };
  };
}
