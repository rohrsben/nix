vim.pack.add({'https://github.com/MagicDuck/grug-far.nvim'})

vim.keymap.set('n', '<leader>q', function () 
    vim.cmd('write')
    require('grug-far').open {
        transient = true,
        prefills = {
            vim.fn.expand('%')
        }
    }
end, {noremap = true, silent = true, desc = 'Grug Far'})

vim.keymap.set('n', '<leader>Q', function () 
    vim.cmd('wal')
    require('grug-far').open {
        transient = true,
    }
end, {noremap = true, silent = true, desc = 'Grug Farrer'})
