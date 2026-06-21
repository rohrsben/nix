{
  den.aspects.localsend = {
    nixos = {
      # opens localsend's firewall port (53317)
      programs.localsend.enable = true;
    };
  };
}
