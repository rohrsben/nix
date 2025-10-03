vim.pack.add({'https://github.com/sindrets/winshift.nvim'}, {load = true})

vim.keymap.set('n', '<leader>w', '<cmd>WinShift<cr>', {noremap = true, silent = true, desc = 'Shift windows'})
