require('blink.cmp').setup {
    keymap = {
        preset = 'none',
        ['<C-j>']   = { 'select_next', 'fallback' },
        ['<C-k>']   = { 'select_prev', 'fallback' },
        ['<C-c>']   = { 'cancel', 'fallback' },
        ['<C-e>']   = {
            'accept',
            function ()
                if #MiniSnippets.expand({insert = false}) > 0 then
                    MiniSnippets.expand()
                    return true
                end

                return false
            end,
            'select_and_accept'
        },
        ['<Tab>']   = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },
    snippets = {
        preset = 'mini_snippets',
    },
    fuzzy = {
        max_typos = 0,
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

                components = {
                    label = {
                        width = { min = 30, max = 30 },
                    },
                },
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
            snippets = { enabled = false },
            buffer   = { name = 'buff' },
        },
    },
}
