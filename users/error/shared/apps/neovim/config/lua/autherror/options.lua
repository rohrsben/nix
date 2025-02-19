vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 4

vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = '󰘍'

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.timeoutlen = 500
vim.opt.fileencoding = 'utf-8'

vim.opt.swapfile = true
vim.opt.updatetime = 300

-- auto-resizes splits on terminal size change
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
})
