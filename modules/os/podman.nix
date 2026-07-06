{
  den.aspects.podman = {
    nixos = {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
  };
}
