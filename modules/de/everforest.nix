{ inputs, ... }: {
  flake-file.inputs.personal.url = "github:rohrsben/personal-nix";

  den.aspects.everforest = {
    nixos = { pkgs, ... }: {
      # todo temp fix for okular see https://discourse.nixos.org/t/virtualbox-under-gnome/74450
      environment = {
        extraInit = ''
            export xdg_data_dirs="$xdg_data_dirs:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        '';
      };
    };

    homeManager = { host, pkgs, ... }:
      let
        gtk  = inputs.personal.packages.${host.system}.gtk;
        icon = inputs.personal.packages.${host.system}.icon;
        qt   = inputs.personal.packages.${host.system}.qt;
      in {
        home.packages = [
          pkgs.kdePackages.qtstyleplugin-kvantum
          pkgs.kdePackages.qt6ct
          pkgs.kdePackages.breeze-icons
          pkgs.kdePackages.qtsvg
        ];

        gtk = {
          enable = true;
          theme = {
            package = gtk;
            name = "Everforest-Red-Dark-Medium";
          };
          iconTheme = {
            package = icon;
            name = "Everforest-Dark";
          };
        };

        # qt theming
        xdg.configFile = {
          "Kvantum/MateriaEverforestDark" = {
            source = "${qt}/share/Kvantum/MateriaEverforestDark";
            recursive = true;
          };
          "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=MateriaEverforestDark";
        };

        home.pointerCursor = {
          gtk.enable = true;

          package = pkgs.phinger-cursors;
          name = "phinger-cursors-dark";
          size = 24;
        };
      };
  };
}
