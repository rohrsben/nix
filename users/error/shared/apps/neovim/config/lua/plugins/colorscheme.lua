return {
    'sainnhe/everforest',
    priority = 1000,
    config = function ()
        vim.cmd.colorscheme('everforest')

        local function hl(target)
            return vim.api.nvim_get_hl(0, {name = target})
        end

        local light = hl('StatusLine').bg
        local dark = hl('CursorLine').bg

        local highlights = {
            sl_mode_insert = {
                fg = hl('BufferInactive').bg,
                bg = hl('Green').fg
            },

            sl_mode_normal = {
                link = 'StatusLine'
            },

            sl_mode_visual = {
                fg = hl('BufferInactive').bg,
                bg = hl('Red').fg
            },

            sl_mode_misc = {
                fg = hl('BufferInactive').bg,
                bg = hl('Normal').fg
            },

            sl_modified = {
                fg = hl('Blue').fg,
                bg = dark
            },

            sl_readonly = {
                fg = hl('Red').fg,
                bg = dark
            },

            sl_filename = {
                fg = hl('Normal').fg,
                bg = dark
            },

            sl_filepath = {
                fg = hl('Grey').fg,
                bg = dark
            },

            sl_diag_1 = {
                fg = hl('DiagnosticError').fg,
                bg = dark
            },

            sl_diag_2 = {
                fg = hl('DiagnosticWarn').fg,
                bg = dark
            },

            sl_diag_3 = {
                fg = hl('DiagnosticInfo').fg,
                bg = dark
            },

            sl_diag_4 = {
                fg = hl('DiagnosticHint').fg,
                bg = dark
            },

            sl_branch = {
                fg = hl('Grey').fg,
                bg = dark
            },

            sl_lsp_no_inlay = {
                fg = hl('Grey').fg,
                bg = dark
            },

            sl_lsp_inlay = {
                fg = hl('Green').fg,
                bg = dark
            },

            sl_filetype = {
                fg = hl('Grey').fg,
                bg = light
            },

            sl_lineinfo = {
                fg = hl('Grey').fg,
                bg = light
            },
        }

        for name, opts in pairs(highlights) do
            vim.api.nvim_set_hl(0, name, opts)
        end
    end
}
