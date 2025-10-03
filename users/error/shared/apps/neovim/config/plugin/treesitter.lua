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

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function (info)
        if info.data.spec.name == 'nvim-treesitter' then
            if vim.g.treesitter_updated == 1 then
                return
            end

            if info.data.kind ~= 'deleted' then
                local nvim_site = vim.fn.stdpath('data') .. '/site'
                local nvim_queries = nvim_site .. '/queries'
                local ts_queries = vim.pack.get({'nvim-treesitter'})[1].path .. '/runtime/queries'

                vim.system(
                    {'rm', '-r', nvim_queries}
                ):wait()

                vim.system(
                    {'cp', '-r', ts_queries, nvim_site}
                ):wait()

                vim.g.treesitter_updated = 1
            end
        end
    end
})

vim.pack.add({{
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main'
}})

