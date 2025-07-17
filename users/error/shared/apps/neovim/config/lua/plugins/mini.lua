return {
    'echasnovski/mini.nvim',
    lazy = false,
    config = function ()
        require('mini.ai').setup()
        require('mini.surround').setup()

        require('mini.jump').setup {
            mappings = {
                repeat_jump = ''
            }
        }

        require('mini.notify').setup {
            lsp_progress = { enable = false, },
        }
        vim.notify = require('mini.notify').make_notify()

        require('mini.git').setup()

        require('mini.diff').setup {
            view = {
                style = 'sign',
                signs = {
                    add = '┃',
                    change = '┃',
                    delete = '┃',
                },
            },
        }

        require('mini.snippets').setup {
            snippets = {
                require('mini.snippets').gen_loader.from_lang()
            },
            mappings = { expand = '', jump_next = '', jump_prev = '' },
            expand = {
                select = function (s, i)
                    require('blink.cmp').cancel()
                    vim.schedule(function() MiniSnippets.default_select(s, i) end)
                end
            }
        }
        -- exit snippet sessions on entering normal mode
        vim.api.nvim_create_autocmd('User', {
            pattern = 'MiniSnippetsSessionStart',
            callback = function ()
                vim.api.nvim_create_autocmd('ModeChanged', {
                    pattern = '*:n',
                    once = true,
                    callback = function ()
                        while MiniSnippets.session.get() do
                            MiniSnippets.session.stop()
                        end
                    end
                })
            end
        })

        -- exit snippets upon reaching final tabstop
        vim.api.nvim_create_autocmd('User', {
            pattern = 'MiniSnippetsSessionJump',
            callback = function (args)
                if args.data.tabstop_to == '0' then MiniSnippets.session.stop() end
            end
        })

        require('mini.jump2d').setup {
            view = {
                dim = true,
                n_steps_ahead = 2,
            },
            mappings = {
                start_jumping = '',
            },
        }
        vim.api.nvim_set_hl(0, "MiniJump2dSpot", {link = "MiniJump2dSpotUnique"})
        vim.keymap.set({'n', 'v', 'i'}, '<C-Space>', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end, {desc = "Activate Jump2d"})

        require('mini.basics').setup {
            options = {
                basic = true,
                extra_ui = false,
                win_borders = 'single',
            },
            mappings = {
                basic = true,
                option_toggle_prefix = '',
                windows = true,
                move_with_alt = true,
            },
            autocommands = {
                basic = true,
            },
        }
        vim.o.listchars = 'tab:> ,extends:…,precedes:…,nbsp:␣'
        vim.o.list = true
        if vim.fn.exists('syntax_on') ~= 1 then vim.cmd([[syntax enable]]) end

        require('mini.align').setup {
            mappings = {
                start = '<leader>a',
                start_with_preview = '<leader>A',
            },
        }

        require('mini.move').setup {
            mappings = {
                left = '',
                right = '',
                down = '<C-j>',
                up = '<C-k>',

                line_left = '',
                line_right = '',
                line_down = '',
                line_up = '',
            },
        }

        require('mini.pairs').setup {
            mappings = {
                ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][%)%]%}%s]' },
                ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][%)%]%}%s]' },
                ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][%)%]%}%s]' },

                [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\][%)%s]' },
                [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\][%]%s]' },
                ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\][%}%s]' },

                ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[%[%]%(%){}%s][%[%]%(%){}%s]', register = { cr = false } },
                ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[%[%]%(%){}%s][%[%]%(%){}%s]', register = { cr = false } },
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[%[%]%(%){}%s][%[%]%(%){}%s]', register = { cr = false } },
            },
        }
    end
}
