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

        require('mini.jump2d').setup {
            spotter = require('mini.jump2d').builtin_opts.word_start.spotter,
            view = {
                dim = true,
                n_steps_ahead = 2,
            },
            mappings = {
                start_jumping = '<C-Space>',
            },
        }
        vim.keymap.set('i', '<C-Space>', function() MiniJump2d.start() end, {noremap = true, silent = true})
        vim.api.nvim_set_hl(0, "MiniJump2dSpot", {link = "MiniJump2dSpotUnique"})

        vim.o.listchars = 'tab:> ,extends:…,precedes:…,nbsp:␣'
        vim.o.list = true
        if vim.fn.exists('syntax_on') ~= 1 then vim.cmd([[syntax enable]]) end
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
                ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
                ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
                ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

                [')'] = { action = 'close',  pair = '()', neigh_pattern = '[^\\].' },
                [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
                ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

                ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[%[%]%(%){}%s][%[%]%(%){}%s]', register = { cr = false } },
                ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[%[%]%(%){}%s][%[%]%(%){}%s]', register = { cr = false } },
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[%[%]%(%){}%s][%[%]%(%){}%s]', register = { cr = false } },
            },
        }
    end
}
