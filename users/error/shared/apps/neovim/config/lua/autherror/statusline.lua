local modes = {
    ['n']  = { hl = 'sl_mode_normal', text = 'NORMAL',       short_text = 'N' },
    ['i']  = { hl = 'sl_mode_insert', text = 'INSERT',       short_text = 'I' },
    ['ic'] = { hl = 'sl_mode_insert', text = 'INSERT',       short_text = 'I' },
    ['no'] = { hl = 'sl_mode_normal', text = 'NORMAL',       short_text = 'N' },
    ['v']  = { hl = 'sl_mode_visual', text = 'VISUAL',       short_text = 'V' },
    ['V']  = { hl = 'sl_mode_visual', text = 'V-LINE',       short_text = 'VL' },
    [''] = { hl = 'sl_mode_visual', text = 'V-BLOCK',      short_text = 'VB' },
    ['s']  = { hl = 'sl_mode_misc',   text = 'SELECT',       short_text = 'S' },
    ['S']  = { hl = 'sl_mode_misc',   text = 'SELECT LINE',  short_text = 'SL' },
    [''] = { hl = 'sl_mode_misc',   text = 'SELECT BLOCK', short_text = 'SB' },
    ['R']  = { hl = 'sl_mode_misc',   text = 'REPLACE',      short_text = 'R' },
    ['Rv'] = { hl = 'sl_mode_misc',   text = 'V-REPLACE',    short_text = 'VR' },
    ['c']  = { hl = 'sl_mode_misc',   text = 'COMMAND',      short_text = 'C' },
    ['cv'] = { hl = 'sl_mode_misc',   text = 'VIM EX',       short_text = 'VE' },
    ['ce'] = { hl = 'sl_mode_misc',   text = 'EX',           short_text = 'E' },
    ['r']  = { hl = 'sl_mode_misc',   text = 'PROMPT',       short_text = 'P' },
    ['rm'] = { hl = 'sl_mode_misc',   text = 'MORE',         short_text = 'M' },
    ['r?'] = { hl = 'sl_mode_misc',   text = 'CONFIRM',      short_text = 'CF' },
    ['!']  = { hl = 'sl_mode_misc',   text = 'SHELL',        short_text = 'S' },
    ['t']  = { hl = 'sl_mode_misc',   text = 'TERMINAL',     short_text = 'T' },
}

local function mode()
    local info = modes[vim.api.nvim_get_mode().mode]
    return '%#' .. info.hl .. '# ' .. info.text .. ' '
end

local function mode_short()
    local info = modes[vim.api.nvim_get_mode().mode]
    return '%#' .. info.hl .. '# ' .. info.short_text .. ' '
end

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')

    local dirs = vim.split(fpath, '/')
    if #dirs > 3 then
        fpath = string.format(' .../%s/%s/%s', dirs[#dirs-2], dirs[#dirs-1], dirs[#dirs])
    end

    return '%#sl_filepath#' .. string.format(' %s/', fpath)
end

local function filename()
    return '%#sl_filename# ' .. vim.fn.expand('%:t')
end

local function buffer_info()
    local info = ''

    if vim.bo.modified then
        info = ' %#sl_modified#󰐗'
    end

    if vim.bo.readonly then
        info = info .. ' %#sl_readonly#[RO]'
    end

    return info
end

local function lsp_and_branch()
    local diagnostics = ''

    local diag_info = {
        {
            type = 'err',
            count = #vim.diagnostic.get(0, {severity = 1}),
            symbol = '●'
        },
        {
            type = 'warn',
            count = #vim.diagnostic.get(0, {severity = 2}),
            symbol = '●'
        },
        {
            type = 'info',
            count = #vim.diagnostic.get(0, {severity = 3}),
            symbol = '●'
        },
        {
            type = 'hint',
            count = #vim.diagnostic.get(0, {severity = 4}),
            symbol = '●'
        },
    }

    for _, diag in ipairs(diag_info) do
        if diag.count > 0 then
            diagnostics = diagnostics .. string.format('%%#sl_diag_%s#%s %d ', diag.type, diag.symbol, diag.count)
        end
    end

    local branch = vim.b.gitsigns_head
    branch = branch ~= nil and '%#sl_branch#' .. branch or ''

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

        return '%#sl_lsp#' .. table.concat(it:totable(), ', ') .. ' '
    end

    return ''
end

local function filetype()
    local ft = vim.bo.filetype
    return ft == '' and '' or '%#sl_filetype# ' .. ft .. ' |'
end

local function lineinfo()
    if vim.bo.filetype == 'alpha' then
        return ''
    end
    return '%#sl_lineinfo# %P %l:%c '
end

function Active()
    local width = vim.fn.winwidth(0)

    if width > 100 then
        return table.concat {
            mode(),
            filepath(),
            filename(),
            buffer_info(),

            '%=',
            lsp_and_branch(),

            '%=',
            lsp_name(),

            filetype(),
            lineinfo(),
        }
    elseif width > 60 then
        return table.concat {
            mode(),
            filename(),
            buffer_info(),

            '%=',
            lsp_and_branch(),

            '%=',
            lsp_name(),

            filetype(),
            lineinfo(),
        }
    else
        return table.concat {
            mode_short(),
            filename(),
            buffer_info(),

            '%=',
            filetype(),
            lineinfo(),
        }
    end
end

function Inactive()
    return '%=%F%='
end

vim.cmd([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Inactive()
    augroup END
]])
