local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map('i', '<C-n>', '<esc>viWsa$Ea', {noremap = false, remap = true})

require('mini.pairs').map_buf(0, 'i', '$', {
    action = 'closeopen',
    pair = '$$',
    neigh_pattern = '[^\\]'
})
