vim.pack.add({{
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main'
}})

vim.api.nvim_create_autocmd('FileType', {
    callback = function (info)
        if vim.treesitter.language.add(vim.bo[info.buf].filetype) then
            -- syntax highlighting
            vim.treesitter.start()
            vim.bo.syntax = 'on'

            -- indent
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end
})
