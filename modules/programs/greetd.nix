{
  den.aspects.greetd = {
    nixos = { pkgs, lib, ... }: {
        services.greetd = {
          enable = true;
          settings.default_session.command = lib.mkDefault "${lib.getExe pkgs.tuigreet} --time --cmd 'uwsm start default'";
        };
      };
  };
}
