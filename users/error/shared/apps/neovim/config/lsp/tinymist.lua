-- commit 9a955d0 (heavily altered)

return {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_dir = function (bufnr, callback)
        local root = vim.fs.root(bufnr, {'.git'}) or vim.fn.getcwd()

        callback(root)
    end,
}
