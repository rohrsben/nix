return {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
        { '<Tab>', function() require('flash').jump() end, desc = 'Flash jump' }
    }
}
