require('mini.pairs').map_buf(0, 'i', '$', {
    action = 'closeopen',
    pair = '$$',
    neigh_pattern = '[^\\]'
})

require('mini.pairs').map_buf(0, 'i', ' ', {
    action = 'closeopen',
    pair = '  ',
    neigh_pattern = '[$][$]',
    register = { bs = false }
})
