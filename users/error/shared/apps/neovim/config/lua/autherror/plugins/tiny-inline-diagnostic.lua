return {
    'rachartier/tiny-inline-diagnostic.nvim',
    config = function ()
        require('tiny-inline-diagnostic').setup {
            preset = 'powerline',
        }
    end
}
