local function map(mode, lhs, rhs, opts)
    local options = vim.tbl_extend('force', opts, { noremap = true, silent = true })
    vim.keymap.set(mode, lhs, rhs, options)
end

local capabilities = require('blink.cmp').get_lsp_capabilities()

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    opts.desc = 'Show LSP references'
    map('n', 'gR', '<cmd>Telescope lsp_references<cr>', opts)

    opts.desc = 'Go to declaration'
    map('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = 'Show LSP definitions'
    map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)

    opts.desc = 'Show LSP implementations'
    map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)

    opts.desc = 'Show LSP type definitions'
    map('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', opts)

    opts.desc = 'See available code actions'
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    opts.desc = 'Smart rename'
    map('n', '<leader>rn', vim.lsp.buf.rename, opts)

    opts.desc = 'Show buffer diagnostics'
    map('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<cr>', opts)

    opts.desc = 'Show line diagnostics'
    map('n', '<leader>d', vim.diagnostic.open_float, opts)

    opts.desc = 'Go to previous diagnostic'
    map('n', '[d', vim.diagnostic.goto_prev, opts)

    opts.desc = 'Go to next diagnostic'
    map('n', ']d', vim.diagnostic.goto_next, opts)

    opts.desc = 'Show documentation for what is under cursor'
    map('n', 'K', vim.lsp.buf.hover, opts)

    require('lsp_signature').on_attach(signature_setup, bufnr)
end

return {
    'pmizio/typescript-tools.nvim',
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = { on_attach = on_attach, capabilities = capabilities, },
    enabled = os.getenv("nvim_typescript") and true or false,
}
