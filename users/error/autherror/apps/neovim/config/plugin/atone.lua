vim.pack.add({'https://github.com/XXiaoA/atone.nvim'})

require('atone').setup {
    layout = {
        direction = 'right'
    },
    keymaps = {
        tree = {
            quit = {'<esc>', 'q'}
        },
    },
}

vim.keymap.set('n', '<leader>u', '<cmd>Atone toggle<cr>', {desc = 'Undo tree'})
