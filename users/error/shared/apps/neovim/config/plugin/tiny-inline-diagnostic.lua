vim.pack.add({'https://github.com/rachartier/tiny-inline-diagnostic.nvim'})

require('tiny-inline-diagnostic').setup {
    preset = 'powerline',
    options = {
        multilines = true,
        show_all_diags_on_cursorline = true,
    },
}
