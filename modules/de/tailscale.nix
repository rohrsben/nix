{
  den.aspects.tailscale = {
    nixos = {
      services.tailscale = {
        enable = true;
        extraSetFlags = [ "--ssh" ];
      };
    };
  };
}
