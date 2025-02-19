local function map(mode, lhs, rhs, opts)
    local options = vim.tbl_extend('force', opts, { noremap = true, silent = true })
    vim.keymap.set(mode, lhs, rhs, options)
end


local on_attach = function (client, bufnr)
    local opts = { buffer = bufnr }

    opts.desc = 'Show line diagnostics'
    map('n', '<leader>d', vim.diagnostic.open_float, opts)

    opts.desc = 'Go to previous diagnostic'
    map('n', '[d', vim.diagnostic.goto_prev, opts)

    opts.desc = 'Go to next diagnostic'
    map('n', ']d', vim.diagnostic.goto_next, opts)

    opts.desc = 'Show documentation for what is under cursor'
    map('n', 'K', vim.lsp.buf.hover, opts)
end

return {
    'tomtomjhj/coq-lsp.nvim',
    dependencies = {
        'whonore/coqtail'
    },
    enabled = os.getenv("nvim_coq") and true or false,
    config = function()
        vim.g.loaded_coqtail = 1
        vim.g["coqtail#supported"] = 0
        require('coq-lsp').setup {
            lsp = {
                on_attach = on_attach,
                init_options = {
                    show_notices_as_diagnostics = true,
                },
            },
        }
    end
}
