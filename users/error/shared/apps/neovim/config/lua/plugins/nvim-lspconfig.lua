return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'saghen/blink.cmp',
    },
    config = function ()
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '●',
                    [vim.diagnostic.severity.WARN]  = '●',
                    [vim.diagnostic.severity.HINT]  = '●',
                    [vim.diagnostic.severity.INFO]  = '●',
                },
            },
            virtual_text = false,
        })

        local default_settings = {
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            on_attach = function (client, bufnr)
                local function map(mode, lhs, rhs, opts)
                    local options = vim.tbl_extend('force', opts, {noremap = true, silent = true, buffer = bufnr})
                    vim.keymap.set(mode, lhs, rhs, options)
                end

                map('n', '<leader>lpr', function() Snacks.picker.lsp_references() end, {desc = 'Show LSP references'})
                map('n', '<leader>lpd', function() Snacks.picker.lsp_definitions() end, {desc = 'Show LSP definitions'})
                map('n', '<leader>lpi', function() Snacks.picker.lsp_implementations() end, {desc = 'Show LSP implementations'})
                map('n', '<leader>lpt', function() Snacks.picker.lsp_type_definitions() end, {desc = 'Show LSP type definitions'})
                map('n', '<leader>lpD', function() Snacks.picker.diagnostics_buffer() end, {desc = 'Show buffer diagnostics'})

                map('n',        '<leader>lr', vim.lsp.buf.rename,        {desc = 'LSP Rename'})
                map({'n', 'v'}, '<leader>la', vim.lsp.buf.code_action,   {desc = 'LSP Code Action'})
                map('n',        '<leader>lD', vim.diagnostic.open_float, {desc = 'LSP Line Diagnostics'})
                map('n',        '<leader>ld', vim.lsp.buf.declaration,   {desc = 'Go to declaration'})
                map('n',        '<leader>li', function ()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    vim.api.nvim_command('redrawstatus!')
                end, { desc = 'Toggle LSP type hints' })
                map('n',        '<leader>lc', function ()
                    vim.lsp.document_color.enable(not vim.lsp.document_color.is_enabled(bufnr), bufnr)
                    vim.api.nvim_command('redrawstatus!')
                end, { desc = 'Toggle LSP color inlay'})
            end
        }

        local servers = {
            tinymist = {
                root_dir = function (_, bufnr)
                    return vim.fs.root(bufnr, { '.git' }) or vim.fn.getcwd()
                end
            },

            rust_analyzer = {},

            clangd = {},

            lua_ls = {
                on_init = function (client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.json')) then
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
