require('mini.pairs').map_buf(0, 'i', '$', {
    action = 'closeopen',
    pair = '$$',
    neigh_pattern = '[^\\]%s'
})

vim.keymap.set('i', '<C-n>', function() MiniSnippets.default_insert({body = 'im'}) end, {desc = 'Inline Math Snippet'})
