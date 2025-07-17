return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        indent = {
            scope = { hl = 'CursorLineNr' },
            chunk = {
                enabled = true,
                hl = 'CursorLineNr'
            },
        },

        picker = {
            sources = {
                explorer = {
                    auto_close = true,
                    win = {list = {keys = {['l'] = ''}}},
                    layout = {
                        layout = {
                            backdrop = false,
                            box = 'horizontal',
                            width = 0.3,
                            min_width = 60,
                            height = 0.8,
                            max_height = 50,
                            {
                                box = 'vertical',
                                border = 'rounded',
                                title = 'Explorer {flags}',
                                { win = 'list',  border = 'bottom'},
                                { win = 'input', height = 1, border = 'none'},
                            }
                        },
                    },
                },
                grep = {
                    layout = function ()
                        return vim.o.columns >= 120 and {
                            layout = {
                                backdrop = false,
                                box = 'horizontal',
                                width = 0.8,
                                min_width = 120,
                                height = 0.8,
                                max_height = 50,
                                {
                                    box = 'vertical',
                                    border = 'rounded',
                                    title = 'Grep',
                                    { win = 'input', height = 1, border = 'bottom' },
                                    { win = 'list', border = 'none' }
                                },
                                { win = 'preview', title = '{preview}', border = 'rounded', width = 0.5 },
                            }
                        } or {
                            layout = {
                                backdrop = false,
                                box = 'vertical',
                                border = 'rounded',
                                width = 0.5,
                                min_width = 60,
                                height = 0.6,
                                title = 'Grep',
                                { win = 'input', height = 1, border = 'bottom' },
                                { win = 'list', border = 'bottom' },
                                { win = 'preview', border = 'none', height = 0.5 }
                            }
                        }
                    end
                },
                files = {
                    follow = true,
                    preview = false,
                    layout = function ()
                        return vim.o.columns >= 120 and {
                            layout = {
                                backdrop = false,
                                box = 'horizontal',
                                width = 0.8,
                                min_width = 120,
                                height = 0.8,
                                max_height = 50,
                                {
                                    box = 'vertical',
                                    border = 'rounded',
                                    title = 'Files',
                                    { win = 'input', height = 1, border = 'bottom' },
                                    { win = 'list',  border = 'none' },
                                },
                                { win = 'preview', title = '{preview}', border = 'rounded', width = 0.5 },
                            }
                        } or {
                            layout = {
                                backdrop = false,
                                box = 'vertical',
                                width = 0.5,
                                min_width = 60,
                                height = 0.4,
                                border = 'rounded',
                                title = 'Files',
                                { win = 'input', height = 1, border = 'bottom' },
                                { win = 'list', border = 'none' },
                            }
                        }
                    end
                },
                buffers = {
                    -- current = false,
                    win = {
                        input = {
                            keys = {
                                ['<C-d>'] = {'bufdelete', mode = {'n', 'i'}},
                                ['<C-x>'] = {'edit_split', mode = {'n', 'i'}},
                            }
                        }
                    },
                    layout = {
                        layout = {
                            backdrop = false,
                            box = 'vertical',
                            width = 50,
                            height = 10,
                            border = 'rounded',
                            title = 'Buffers',
                            { win = 'input', height = 1, border = 'bottom' },
                            { win = 'list', border = 'none' },
                        },
                    },
                },
            },
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close',      mode = {'n', 'i'} },
                        ['<C-x>'] = { 'edit_split', mode = {'n', 'i'} }
                    },
                },
                list = {
                    keys = {
                        ['<C-x>'] = {'edit_split'}
                    },
                },
            },
            layout = {
                layout = {
                    backdrop = false,
                },
            }
        },

        statuscolumn = {},
        input = {},
        explorer = {},

        styles = {
            input = {
                relative = 'cursor',
            },
        },
    },

    keys = {
        { '<leader>o', function() Snacks.picker.files() end,    desc = 'Find files' },
        { '<leader>g', function() Snacks.picker.grep() end,     desc = 'Grep working dir' },
        { '<leader>b', function() Snacks.picker.buffers() end,  desc = 'Buffer list' },
        { '<leader>e', function() Snacks.picker.explorer() end, desc = 'File tree' },
        { '<leader>p', function() Snacks.picker.pickers() end,  desc = 'Picker picker' },
    },
}
