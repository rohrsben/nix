return {
    'nvchad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('colorizer').setup {
            user_default_options = {
                RRGGBBAA = true,
                rgb_fn = true,
            },
        }
    end
}
