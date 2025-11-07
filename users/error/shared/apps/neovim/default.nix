{ inputs, pkgs, config, ... }:

let
    ts-parsers = inputs.personal.packages.${pkgs.stdenv.hostPlatform.system}.treesitter-parsers;
in {
    home = {
        packages = [
            pkgs.lua-language-server
            pkgs.tinymist
            pkgs.websocat
            pkgs.tree-sitter
            ts-parsers
        ];

        sessionVariables = {
            MANPAGER = "nvim +Man!";
        };
    };

    programs.neovim = {
        enable = true;
        package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
                    ['tinymist'] = "${pkgs.tinymist}/bin/tinymist",
                    ['websocat'] = "${pkgs.websocat}/bin/websocat"
                },
            }
        '';
    };
}
