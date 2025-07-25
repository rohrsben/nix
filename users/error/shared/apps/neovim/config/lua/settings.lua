-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrw_gitignore = 1

-- how close the cursor can get to the window edge
vim.o.scrolloff = 5
vim.o.sidescrolloff = 4

-- word wrap settings
vim.o.wrap = true
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.showbreak = '󰘍'

-- tab as 4 spaces
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

-- "under the hood" ux settings
vim.o.timeoutlen = 500
vim.o.fileencoding = 'utf-8'
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.mouse = 'a'

-- ui settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.winborder = 'rounded'
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = 'topline'
vim.o.ruler = false
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.shortmess = 'ltToOcCWF'
vim.o.listchars = 'tab:> ,extends:…,precedes:…,nbsp:␣'
vim.o.list = true

-- search, indent, etc settings
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.virtualedit = 'block'
vim.o.formatoptions = 'qjl1'

-- space as leader
vim.g.maplocalleader = ' '
vim.g.mapleader = ' '

-- fold settings
-- vim.o.foldcolumn = '0' -- this is a default
-- vim.o.foldenable = true -- this is a default
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldtext = ''
vim.o.fillchars = 'fold: ,'


local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map('', '<Space>', '<Nop>')

-- don't overwrite the register on x, (c)hanges, or pasting in visual
map('n', 'x', '"_x')
map('n', 'c', '"_c')
map('n', 'cc', '"_cc')
map('n', 'C', '"_C')
map('x', 'p', '"_dP')

-- don't deselect on indentations
map('x', '<', '<gv')
map('x', '>', '>gv')

-- cursor centering
map('i', '<C-z>', '<C-o>zz', { desc = "Center the cursorline in insert"})
map('n', 'z=', 'z+')

-- j and k operate on visible lines
map({'n', 'x'}, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({'n', 'x'}, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- copy and paste with system clipboard
map({'n', 'x'}, 'gy', '"+y', { desc = 'Yank to system clipboard'})
map('n', 'gp', '"+p', { desc = 'Paste from system clipboard'})
map('x', 'gp', '"+P', { desc = 'Paste from system clipboard'})

-- reselect latest changed/put/yanked text
map('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"',
    { expr = true, replace_keycodes = false, desc = 'Visually select changed text'})

-- move between splits better
map('n', '<C-H>', '<C-w>h', { desc = 'Focus on left window' })
map('n', '<C-J>', '<C-w>j', { desc = 'Focus on below window' })
map('n', '<C-K>', '<C-w>k', { desc = 'Focus on above window' })
map('n', '<C-L>', '<C-w>l', { desc = 'Focus on right window' })

-- resize splits
map('n', '<C-Up>',    '<C-w>+', { desc = 'Increase split height'})
map('n', '<C-Down>',  '<C-w>-', { desc = 'Decrease split height'})
map('n', '<C-Right>', '<C-w>>', { desc = 'Increase split width'})
map('n', '<C-Left>',  '<C-w><', { desc = 'Decrease split width'})

-- interchange ; and :
map({'n', 'v'}, ';', ':', { silent = false })
map({'n', 'v'}, ':', ';')

-- turn off highlights
map('n', '<leader>h', '<cmd>nohlsearch<cr>')

-- toggle native type inlays
map('n', '<leader>i', function ()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    vim.api.nvim_command('redrawstatus!')
end)

-- U is redo
map('n', 'U', '<C-r>')

-- R is replace inner word
map('n', 'R', 'ciw')


local autocmd = vim.api.nvim_create_autocmd

-- autosave
autocmd({'BufLeave', 'FocusLost', 'VimLeavePre'}, {
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

-- auto-resize splits on window size change
autocmd('VimResized', {
    command = 'wincmd =',
})

-- enable lsp folding per buffer, if supported
autocmd('LspAttach', {
    callback = function (args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
    end
})

-- highlight on yank
autocmd('TextYankPost', {
    pattern = '*',
    callback = function ()
        vim.hl.on_yank { higroup = 'CurSearch', timeout = 300 }
    end
})
