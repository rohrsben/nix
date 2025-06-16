local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- how close the cursor can get to the window edge
vim.o.scrolloff = 5
vim.o.sidescrolloff = 4

-- word wrap settings
vim.o.wrap = true
vim.o.breakindent = true
vim.o.showbreak = '󰘍'

-- tab as 4 spaces
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

-- "under the hood" ux settings
vim.o.timeoutlen = 500
vim.o.fileencoding = 'utf-8'

vim.o.relativenumber = true


-- space as leader
map('', '<Space>', '<Nop>')
vim.g.maplocalleader = ' '
vim.g.mapleader = ' '

-- don't overwrite the register on x, (c)hanges, or pasting in visual
map('n', 'x', '"_x')
map('n', 'c', '"_c')
map('n', 'cc', '"_cc')
map('n', 'C', '"_C')
map('x', 'p', '"_dP')

-- don't deselect on indentations
map('x', '<', '<gv')
map('x', '>', '>gv')

-- interchange ; and :
map({'n', 'v'}, ';', ':', { silent = false })
map({'n', 'v'}, ':', ';')

-- turn off highlights
map('n', '<leader>h', '<cmd>nohlsearch<cr>')

-- toggle native type inlays
map('n', '<leader>i', function ()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    vim.api.nvim_command('redrawstatus!')
end)

-- U is redo
map('n', 'U', '<C-r>')

-- R is replace inner word
map('n', 'R', 'ciw')


local autocmd = vim.api.nvim_create_autocmd

-- autosave
autocmd({'BufLeave', 'FocusLost', 'VimLeavePre'}, {
    callback = function (event)
        local buf = event.buf
        if vim.api.nvim_get_option_value('modified', {buf = buf}) then
            vim.schedule(function ()
                vim.api.nvim_buf_call(buf, function ()
                    vim.cmd 'silent! write'
                end)
            end)
        end
    end
})

-- auto-resize splits on window size change
autocmd('VimResized', {
    command = 'wincmd =',
})
