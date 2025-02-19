return {
    'MagicDuck/grug-far.nvim',
    keys = {
        { '<leader>q', function ()
            vim.cmd('write')
            require("grug-far").open {
                transient = true,
                prefills = {
                    paths = vim.fn.expand("%")
                }
            }
        end, desc = "Grug Far" },

        { '<leader>Q', function ()
            vim.cmd('wal')
            require("grug-far").open {
                transient = true,
            }
        end, desc = "Grug Farrer" }
    },
}
