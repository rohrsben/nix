local function start_blink()
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
                -- BUG tracking: saghen/blink.cmp#1932
                auto_show_delay_ms = 10,

                scrolloff = 2,
                draw = {
                    columns = { {'kind_icon'}, {'label'}, {'source_name'} },

                    -- BUG tracking: saghen/blink.cmp#1932
                    components = {
                        label = {
                            width = { min = 25, max = 25 },
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
                snippets = { name = 'snip' },
                buffer   = { name = 'buff' },
            },
        },
    }
end

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function (info)
        if info.data.spec.name == 'blink.cmp' then
            if vim.g.blink_updated == 1 then
                return
            end

            local result
            if info.data.kind ~= 'deleted' then
                vim.notify('Building Blink')
                vim.g.blink_updated = 1

                result = vim.system(
                    {'nix', 'run', '.#build-plugin'},
                    { cwd = info.data.path }
                ):wait()
            end

            if info.data.kind == 'installed' then
                if result.code == 0 then
                    vim.api.nvim_create_autocmd('UIEnter', {
                        once = true,
                        callback = function ()
                            vim.notify('Blink build successful. Starting')
                            start_blink()
                        end
                    })
                else
                    vim.api.nvim_create_autocmd('UIEnter', {
                        once = true,
                        callback = function ()
                            vim.notify('Blink build failed. Code: ' .. result.code)
                        end
                    })
                end
            elseif info.data.kind == 'updated' then
                if result.code == 0 then
                    vim.notify('Blink build successful. Starting')
                    start_blink()
                else
                    vim.notify('Blink build failed. Code: ' .. result.code)
                end
            end
        end
    end
})

vim.pack.add({'https://github.com/Saghen/blink.cmp'})

if vim.g.blink_updated == nil then start_blink() end
