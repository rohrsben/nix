return {
    'Saghen/blink.cmp',
    build = 'nix run .#build-plugin',
    opts = {
        keymap = {
            preset = 'none',
            ['<C-j>']   = { 'select_next', 'fallback' },
            ['<C-k>']   = { 'select_prev', 'fallback' },
            ['<C-c>']   = { 'cancel', 'fallback' },
            ['<C-e>']   = {
                'accept',
                function ()
                    MiniSnippets.expand()
                end
            },
            ['<Tab>']   = { 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        },
        snippets = {
            preset = 'mini_snippets',
        },
        fuzzy = {
            max_typos = function(_) return 0 end,
            sorts = {
                'score',
                'sort_text'
            },
        },
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 350 },
            accept = { dot_repeat = false },
            keyword = { range = 'full' },
            list = {
                selection = { preselect = false, auto_insert = true },
            },
            menu = {
                scrolloff = 2,
                draw = {
                    columns = { {'kind_icon'}, {'label'}, {'source_name'} },
                },
            },
        },
        signature = {
            enabled = true,
            window = {
                show_documentation = false,
            },
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
                lsp      = { name = 'lsp'  },
                path     = { name = 'path' },
                snippets = { name = 'snip' },
                buffer   = { name = 'buff' },
            },
        },
    },
}
