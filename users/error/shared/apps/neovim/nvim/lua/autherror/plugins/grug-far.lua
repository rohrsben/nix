return {
    'MagicDuck/grug-far.nvim',
    config = function()
        require('grug-far').setup {
        }
    end,
    keys = {
        { '<leader>q', function ()
            require("grug-far").open {
                transient = true,
                prefills = {
                    paths = vim.fn.expand("%")
                }
            }
        end, desc = "Grug Far" }
    },
}
