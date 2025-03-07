{ inputs, pkgs, config, ... }:

let
    app = "nvim";
    configDir = ./config;

    plugins = "nvim/lua/autherror/plugins";
    lazyLock = "/home/error/nix/users/error/shared/apps/neovim/lazy-lock.json";
in {
    home = {
        packages = [
            pkgs.tinymist
            pkgs.websocat
        ];

        sessionVariables = {
            MANPAGER = "nvim +Man!";
        };
    };

    programs.neovim = {
        enable = true;
        package = inputs.neovim-nightly.packages.${pkgs.system}.default;

        viAlias = true;
        vimAlias = true;
        defaultEditor = true;

        plugins = with pkgs.vimPlugins; [
            nvim-treesitter.withAllGrammars
        ];

        extraPackages = with pkgs; [
            lua-language-server
        ];
    };

    xdg.configFile."${app}" = {
        source = "${configDir}";
        recursive = true;
    };

    xdg.configFile."treesitter" = {
        target = "${plugins}/treesitter.lua";
        text = ''
            return {
                dir = "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}",
                name = "nvim-treesitter",
                priority = 500,
                config = function ()
                    require('nvim-treesitter.configs').setup {
                        auto_install = false,
                        highlight = {
                            enable = true,
                        },
                        indent = {
                            enable = true,
                        },
                        incremental_selection = {
                            enable = true,
                            keymaps = {
                                init_selection = "<leader>s",
                                node_incremental = "<C-=>",
                                node_decremental = "<C-->",
                            },
                        }
                    }
                end
            }
        '';
    };

    xdg.configFile."typstpreview" = {
        target = "${plugins}/typst-preview.lua";
        text = ''
            return {
                'chomosuke/typst-preview.nvim',
                ft = 'typst',
                config = function ()
                    require('typst-preview').setup {
                        debug = false,
                        dependencies_bin = {
                            ['tinymist'] = "${pkgs.tinymist}/bin/tinymist",
                            ['websocat'] = "${pkgs.websocat}/bin/websocat",
                        },
                    }
                end
            }
        '';
    };

    xdg.configFile."nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${lazyLock}";
}
