vim.api.nvim_set_hl(0, 'ins', {fg = '#232a2e', bg = '#a7c080'})
vim.api.nvim_set_hl(0, 'vis', {fg = '#232a2e', bg = '#e67e80'})
vim.api.nvim_set_hl(0, 'rand', {fg = '#232a2e', bg = '#d3c6aa'})
vim.api.nvim_set_hl(0, 'CSL1', {fg = '#859289', bg = '#3d484d'})
vim.api.nvim_set_hl(0, 'modified', {fg = "#7fbbb3", bg = '#343f44'})

local modes = {
    ['n'] = '%#CSL1# NORMAL',
    ['no'] = '%#CSL1# NORMAL',
    ['v'] = '%#vis# VISUAL',
    ['V'] = '%#vis# V-LINE',
    [''] = '%#vis# V-BLOCK',
    ['s'] = '%#rand# SELECT',
    ['S'] = '%#rand# SELECT LINE',
    [''] = '%#rand# SELECT BLOCK',
    ['i'] = '%#ins# INSERT',
    ['ic'] = '%#ins# INSERT',
    ['R'] = '%#rand# REPLACE',
    ['Rv'] = '%#rand# V-REPLACE',
    ['c'] = '%#rand# COMMAND',
    ['cv'] = '%#rand# VIM EX',
    ['ce'] = '%#rand# EX',
    ['r'] = '%#rand# PROMPT',
    ['rm'] = '%#rand# MOAR',
    ['r?'] = '%#rand# CONFIRM',
    ['!'] = '%#rand# SHELL',
    ['t'] = '%#term# TERMINAL',
}

local function mode()
    return modes[vim.api.nvim_get_mode().mode] .. ' '
end

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
    local dirs = vim.split(fpath, '/')

    if fpath == '.' or vim.fn.winwidth(0) < 70 then
        return ''
    elseif #dirs > 3 then
        return string.format(' .../%s/%s/%s/', dirs[#dirs-2], dirs[#dirs-1], dirs[#dirs])
    end

    return string.format(' %s/', fpath)
end

local function filename()
    local fname = vim.fn.expand '%:t'

    if vim.bo.modified then
        fname = fname .. ' %#modified#󰐗%#CSL3#'
    end

    if vim.bo.readonly then
        fname = fname .. ' %#CSL4#[RO]'
    end

    return fname
end

vim.api.nvim_set_hl(0, 'DiagError', {fg = '#e67e80', bg = '#343f44'})
vim.api.nvim_set_hl(0, 'DiagWarn', {fg = '#dbbc7f', bg = '#343f44'})
vim.api.nvim_set_hl(0, 'DiagInfo', {fg = '#7fbbb3', bg = '#343f44'})
vim.api.nvim_set_hl(0, 'DiagHint', {fg = '#a7c080', bg = '#343f44'})

local function lsp_and_branch()
    local diagnostics = {}

    local errs = #vim.diagnostic.get(0, {severity = 1})
    local warns = #vim.diagnostic.get(0, {severity = 2})
    local infos = #vim.diagnostic.get(0, {severity = 3})
    local hints = #vim.diagnostic.get(0, {severity = 4})

    if errs > 0 then
        table.insert(diagnostics, '%#DiagError#● ' .. tostring(errs))
    end
    if warns > 0 then
        table.insert(diagnostics, '%#DiagWarn#● ' .. tostring(warns))
    end
    if infos > 0 then
        table.insert(diagnostics, '%#DiagInfo#● ' .. tostring(infos))
    end
    if hints > 0 then
        table.insert(diagnostics, '%#DiagHint#● ' .. tostring(hints))
    end

    local diagnostics = table.concat(diagnostics, ' ')
    local branch = vim.b.gitsigns_head
    branch = branch ~= nil and branch or ''

    if branch ~= '' and diagnostics ~= '' then
        return branch .. ' | ' .. diagnostics
    end

    return branch .. diagnostics
end


local function lsp_name()
    if rawget(vim, 'lsp') then
        local it = vim.iter(vim.lsp.get_clients {bufnr = 0})
        it:map(function (client)
            local name = client.name:gsub('language.server', 'ls')
            return name
        end)

        return string.format('%s', table.concat(it:totable(), ',')) .. ' '
    end

    return ''
end

local function filetype()
    local ft = vim.bo.filetype
    return ft == "" and '' or string.format(' %s |', ft)
end

local function lineinfo()
    if vim.bo.filetype == 'alpha' then
        return ''
    end
    return ' %P %l:%c '
end

Statusline = {}

vim.api.nvim_set_hl(0, 'CSL1', {fg = '#859289', bg = '#3d484d'})
vim.api.nvim_set_hl(0, 'CSL2', {fg = '#859289', bg = '#343f44'})
vim.api.nvim_set_hl(0, 'CSL3', {fg = '#d3c6aa', bg = '#343f44'})
vim.api.nvim_set_hl(0, 'CSL4', {fg = '#e67e80', bg = '#343f44'})

Statusline.active = function ()
    return table.concat {
        mode(),

        '%#CSL2#',
        filepath(),

        '%#CSL3# ',
        filename(),

        '%#CSL2#%=',
        lsp_and_branch(),

        '%=',

        '%#CSL2#',
        lsp_name(),

        '%#CSL1#',
        filetype(),
        lineinfo(),
    }
end

function Statusline.inactive()
    return '%=%F%='
end

vim.cmd([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    augroup END
]])
