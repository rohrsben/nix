require('mini.pairs').map_buf(0, 'i', '$', {
    action = 'closeopen',
    pair = '$$',
    neigh_pattern = '[^\\]%s'
})

vim.keymap.set('i', '<C-n>', function() MiniSnippets.default_insert({body = '$$1$'}) end, {desc = 'Inline Math Snippet'})
vim.keymap.set('n', '<leader>ts', '<cmd>TypstPreview<cr>', {desc = "Start the typst preview"})
vim.keymap.set('n', '<leader>tq', '<cmd>TypstPreviewStop<cr>', {desc = "Stop the typst preview"})
