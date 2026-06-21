{ inputs, ... }: {
  flake-file.inputs.hyprsplit.url = "github:shezdy/hyprsplit";

  den.aspects.hyprland = {
    nixos = {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

    homeManager = { host, pkgs, ... }: {
      home.packages = [ pkgs.grimblast pkgs.hyprpolkitagent pkgs.hyprshutdown];

      xdg.configFile."hypr/hyprland.lua".source = ./config/hyprland.lua;
      xdg.configFile."uwsm/env".text = ''
        export LIBVA_DRIVER_NAME=nvidia
        export QT_QPA_PLATFORM=wayland
        export QT_QPA_PLATFORMTHEME=qt6ct
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      '';

      wayland.windowManager.hyprland = {
        configType = "lua"; # TODO state version thing
        systemd.enable = false; # for uwsm
        enable = true;
        extraLuaFiles = {
          "hyprsplit/init.lua" = {
            autoLoad = false;
            content = builtins.readFile "${inputs.hyprsplit.packages.${host.system}.hyprsplitlua}/share/hyprsplit/init.lua";
          };
        };
      };
    };
  };
}
