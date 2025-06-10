return {
    'rachartier/tiny-inline-diagnostic.nvim',
    config = function ()
        require('tiny-inline-diagnostic').setup {
            preset = 'powerline',
            options = {
                multilines = true,
                show_all_diags_on_cursorline = true,
            },
        }
    end
}
