return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'saghen/blink.cmp',
    },
    config = function ()
        local signs = { Error = '●', Warn = '●', Hint = '●', Info = '●'}
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end

        local default_settings = {
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            on_attach = function (client, bufnr)
                local function map(mode, lhs, rhs, opts)
                    local options = vim.tbl_extend('force', opts, { noremap = true, silent = true, buffer = bufnr})
                    vim.keymap.set(mode, lhs, rhs, options)
                end

                map('n', 'gR', function() Snacks.picker.lsp_references() end, {desc = 'Show LSP references'})
                map('n', 'gD', vim.lsp.buf.declaration, {desc = 'Go to declaration'})
                map('n', 'gd', function() Snacks.picker.lsp_definitions() end, {desc = 'Show LSP definitions'})
                map('n', 'gi', function() Snacks.picker.lsp_implementations() end, {desc = 'Show LSP implementations'})
                map('n', 'gt', function() Snacks.picker.lsp_type_definitions() end, {desc = 'Show LSP type definitions'})
                map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {desc = 'See available code actions'})
                map('n', '<leader>rn', vim.lsp.buf.rename, {desc = 'Smart rename'})
                map('n', '<leader>D', function() Snacks.picker.diagnostics_buffer() end, {desc = 'Show buffer diagnostics'})
                map('n', '<leader>d', vim.diagnostic.open_float, {desc = 'Show line diagnostics'})
                map('n', '[d', function() vim.diagnostic.goto_prev {float = false} end, {desc = 'Go to previous diagnostic'})
                map('n', ']d', function() vim.diagnostic.goto_next {float = false} end, {desc = 'Go to next diagnostic'})
                map('n', 'K', vim.lsp.buf.hover, {desc = 'Show documentation for what is under cursor'})
            end
        }

        local servers = {
            tinymist = {
                offset_encoding = 'utf-8',
                root_dir = function (filename, bufnr)
                    return vim.fn.getcwd()
                end
            },

            rust_analyzer = {
                -- settings = {
                --     ['rust-analyzer'] = {
                --         diagnostics = {
                --             enable = false
                --         }
                --     }
                -- }
            },

            clangd = {},

            lua_ls = {
                on_init = function (client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.json') then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = { version = 'LuaJIT' },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME }
                        }
                    })
                end,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                [vim.fn.stdpath('config') .. '/lua'] = true,
                            },
                        },
                    },
                },
            }
        }

        for server, server_settings in pairs(servers) do
            require('lspconfig')[server].setup(vim.tbl_extend('force', default_settings, server_settings))
        end
    end
}
