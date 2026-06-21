{
  den.aspects.greetd = {
    nixos = { pkgs, lib, ... }: 
      let
        start_cmd = "uwsm start default";
      in {
        services.greetd = {
          enable = true;
          settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --cmd '${start_cmd}'";
        };
      };
  };
}
