vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 4

vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = '󰘍'

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.timeoutlen = 500
vim.opt.fileencoding = 'utf-8'

vim.opt.relativenumber = true

-- autosave
vim.api.nvim_create_autocmd({'BufLeave', 'FocusLost', 'VimLeavePre'}, {
    callback = function (event)
        local buf = event.buf
        if vim.api.nvim_get_option_value('modified', {buf = buf}) then
            vim.schedule(function ()
                vim.api.nvim_buf_call(buf, function ()
                    vim.cmd 'silent! write'
                end)
            end)
        end
    end
})

-- auto-resizes splits on terminal size change
vim.api.nvim_create_autocmd('VimResized', {
    command = 'wincmd =',
})
