{ inputs, ... }: {
  flake-file.inputs.neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

  den.aspects.neovim = {
    homeManager = { host, pkgs, lib, ... }:
      let
        ts-parsers = pkgs.symlinkJoin {
          name = "ts-parsers";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };
      in {
        home.packages = [ pkgs.lua-language-server ts-parsers ];

        programs.neovim = {
          enable = true;
          package = inputs.neovim-nightly.packages.${host.system}.default;

          viAlias = true;
          vimAlias = true;
          defaultEditor = true;
        };

        xdg.configFile."nvim" = {
          source = ./config;
          recursive = true;
        };

        xdg.configFile."nvimmisc" = {
          target = "nvim/lua/misc.lua";
          text = ''
            vim.opt.runtimepath:prepend('${ts-parsers}')
          '';
        };

        xdg.configFile."typstpreview" = {
          target = "nvim/plugin/typst-preview.lua";
          text = ''
            vim.pack.add({'https://github.com/chomosuke/typst-preview.nvim'}, {load = true})

            require('typst-preview').setup {
                debug = false,
                dependencies_bin = {
                    ['tinymist'] = "${lib.getExe pkgs.tinymist}",
                    ['websocat'] = "${lib.getExe pkgs.websocat}"
                },
            }
          '';
        };
      };
  };
}
