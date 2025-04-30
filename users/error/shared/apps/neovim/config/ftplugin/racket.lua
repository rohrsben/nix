local function snipmap(lhs, snip, descr)
    vim.keymap.set('i', lhs, function() require("luasnip").snip_expand(snip) end, {noremap = true, silent = true, desc = descr})
end

local function map(lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set({"i", "s"}, lhs, rhs, options)
end

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snipped_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

local function feedkey(key, mode)
    vim.fn.feedkeys(vim.keycode(key), mode or vim.api.nvim_get_mode().mode)
end


map("<Tab>", function ()
    return ls.jumpable(1) and ls.jump(1) or feedkey("<Tab>", "n")
end)

map("<S-Tab>", function ()
    return ls.jumpable(-1) and ls.jump(-1) or feedkey("<S-Tab>", "n")
end)

map("<C-n>", function ()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

map("<C-p>", function ()
    if ls.choice_active() then
        ls.change_choice(-1)
    end
end)

local function rack(start)
    return c(start, {
        sn(nil, {
            t({"(check-true ("}),
            i(1, "func call"),
            t({"))"}), i(0)
        }),

        sn(nil, {
            t({"(check-equal? ("}),
            i(1, "first"),
            t({") "}),
            i(2, "second"),
            t({")"}), i(0)
        }),

        sn(nil, {
            t({"(check-false ("}),
            i(1, "func call"),
            t({"))"}), i(0)
        }),

        sn(nil, {
            t("(check-exn exn:fail:syntax:cs450?"),
            t("  (lambda () ("), i(1, "func"), t(")))"), i(0)
        })
    })
end

local testcase = s("testcase", {
    t({"(test-case", ""}),
    t(' "'), i(1, "test name"), t({'"', " "}),
    rack(2),
    t({")", "", ""}), i(0)
})

local newdefine = s("newdefine", {
    t({"(define "}), i(1, "name"), t({" "}), i(2, "value"), t(")", "")
})

local omit = s("omittance", {
    t({";; OMITTING: "}), i(1, "functions"),
    t({"", ";; REASON: "}), i(2, "reason"),
    t({"", ";; All omitted deep tests still have example tests!", "", ""}), i(0)
})

local rackunit = s("funcexample", {
    rack(1), t(""), i(0)
})

local newfunc = s("newfunction", {
    t("(define"),
    c(1, {
        sn(nil, {
            t("/contract ("),
            i(1, "func"),
            t({")", "  (-> "}),
            i(2, "types"),
            t(")")
        }),

        sn(nil, {
            t(" ("),
            i(1, "func"),
            t(")")
        }),
    }),
    t({"", "  "}),
    i(2, "body"),
    t({")", ""}), i(0)
})

snipmap('<C-1>', rackunit, "Insert rackunit test")
snipmap('<C-o>', omit, "Test omittance notice")
snipmap('<C-2>', testcase, "Create a rackunit test-case")
snipmap('<C-d>', newdefine, "Create a new racket define")
snipmap('<C-f>', newfunc, "Create a function")

MiniPairs.unmap('i', '`', '``')
