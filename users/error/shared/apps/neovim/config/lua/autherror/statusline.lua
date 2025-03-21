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

local function lsp_info(request)
    local info = vim.lsp.get_clients({bufnr = 0})
    if next(info) == nil then
        return ''
    end

    if request == 'names' then
        local names = vim.iter(info):map(function (client)
            local name = client.name:gsub('language.server', 'ls')
            return name
        end):totable()

        return '%#sl_lsp#' .. table.concat(names, ', ') .. ' '
    else
        local formatted_diags = ''

        local signs = vim.diagnostic.config().signs.text
        local diags = vim.diagnostic.count(0)

        for severity, count in pairs(diags) do
            formatted_diags = formatted_diags .. string.format('%%#sl_diag_%d#%s %d ', severity, signs[severity], count)
        end

        return formatted_diags
    end
end


local function diags_and_branch()
    local diagnostics = lsp_info('diagnostics')

    local branch = vim.b.gitsigns_head
    branch = branch ~= nil and '%#sl_branch#' .. branch or ''

    if branch ~= '' and diagnostics ~= '' then
        return branch .. ' | ' .. diagnostics
    end

    return branch .. diagnostics
end

local function filetype()
    local ft = vim.bo.filetype
    return ft == '' and '' or '%#sl_filetype# ' .. ft .. ' |'
end

local function pos_info()
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
            diags_and_branch(),

            '%=',
            lsp_info('names'),

            filetype(),
            pos_info(),
        }
    elseif width > 60 then
        return table.concat {
            mode(),
            filename(),
            buffer_info(),

            '%=',
            diags_and_branch(),

            '%=',
            lsp_info('names'),

            filetype(),
            pos_info(),
        }
    else
        return table.concat {
            mode_short(),
            filename(),
            buffer_info(),

            '%=',
            filetype(),
            pos_info(),
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
