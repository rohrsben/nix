-- this function just makes remaps cleaner
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- space as leader
map('', '<Space>', '<Nop>')
vim.g.maplocalleader = ' '
vim.g.mapleader = ' '

-- comments using C-/ instead of gc[c]
map('n', '<C-/>', 'gcc', {remap = true})
map('x', '<C-/>', 'gc', {remap = true})

-- various blackhole remaps
map('n', 'x', '"_x')
map('n', 'c', '"_c')
map('n', 'cc', '"_cc')
map('n', 'C', '"_C')

-- interchange ; and :, since i use : more often and hate shift
map({'n', 'v'}, ';', ':', { silent = false })
map({'n', 'v'}, ':', ';')

-- leader / custom mappings

map('n', '<leader>h', '<cmd>nohlsearch<cr>') -- turn off search highlights

-- toggle native type inlays
map('n', '<leader>i', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

-- override mappings

map('n', 'U', '<C-r>') -- U is redo
map('n', 'R', 'ciw') -- replace word

-- mappings for visual mode

map('x', 'p', '"_dP') -- don't overwrite the copy when pasting in visual mode
map('x', '<', '<gv') -- don't deselect on indentation operations
map('x', '>', '>gv') -- same deal
