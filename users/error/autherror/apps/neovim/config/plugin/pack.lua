local function gh(name)
    return 'https://github.com/' .. name
end

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function (info)
        local name = info.data.spec.name
        local kind = info.data.kind
        if name == 'blink.cmp' and kind ~= 'deleted' then
            vim.system(
                {'nix', 'build', '.'},
                { cwd = info.data.path }
            ):wait()
        end
    end
})


vim.pack.add {
    gh('XXiaoA/atone.nvim'),
    gh('saghen/blink.lib'),
    gh('Saghen/blink.cmp'),
    gh('sainnhe/everforest'),
    gh('j-hui/fidget.nvim'),
    gh('MagicDuck/grug-far.nvim'),
    gh('nvim-mini/mini.nvim'),
    gh('karb94/neoscroll.nvim'),
    gh('gennaro-tedesco/nvim-peekup'),
    gh('HiPhish/rainbow-delimiters.nvim'),
    gh('folke/snacks.nvim'),
    gh('abecodes/tabout.nvim'),
    gh('rachartier/tiny-inline-diagnostic.nvim'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('sindrets/winshift.nvim'),
}
