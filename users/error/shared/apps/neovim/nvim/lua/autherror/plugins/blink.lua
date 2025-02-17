return {
    'Saghen/blink.cmp',
    build = 'nix run .#build-plugin',
    opts = {
        keymap = {
            preset = 'none',
            ['<C-j>']   = { 'select_next', 'fallback' },
            ['<C-k>']   = { 'select_prev', 'fallback' },
            ['<C-c>']   = { 'cancel' },
            ['<CR>']    = { 'accept', 'fallback' },
            ['<Tab>']   = { 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        },
        completion = {
            list = {
                selection = { preselect = false, auto_insert = true },
            },
            menu = {
                scrolloff = 1,
                draw = {
                    columns = { {'kind_icon'}, {'label'}, {'source_name'} },
                },
            },
        },
        signature = {
            enabled = true,
        },
        appearance = {
            kind_icons = {
                Text = '󰉿',
                Method = '󰆧',
                Function = '󰊕',
                Constructor = '',

                Field = '󰜢',
                Variable = '󰀫',
                Property = '󰜢',

                Class = "󰠱",
                Interface = "",
                Struct = "󰙅",
                Module = "",

                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                EnumMember = "",

                Keyword = '󰻾',
                Constant = '󰏿',

                Snippet = '',
                Color = '󰏘',
                File = '󰈔',
                Reference = '󰈇',
                Folder = '󰉋',
                Event = '󱐋',
                Operator = '󰪚',
                TypeParameter = '󰬛',
            },
        },
        sources = {
            providers = {
                lsp = { name = 'lsp' },
                path = { name = 'path' },
                snippets = { name = 'snip' },
                buffer = { name = 'buff' },
            },
        },
    },
}
