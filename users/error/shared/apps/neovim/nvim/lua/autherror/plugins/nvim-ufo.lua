return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async'
    },
    event = 'VeryLazy',
    config = function()
        vim.opt.foldcolumn = '1'
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true

        require('ufo').setup()
    end
}
