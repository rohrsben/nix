vim.pack.add({"https://github.com/OXY2DEV/markview.nvim"}, {load = true})

require("markview").setup {
    typst = { enable = false },
}
