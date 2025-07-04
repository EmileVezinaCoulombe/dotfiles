local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local snippets = {
    s("gwt", {
        t("describe('GIVEN "),
        i(1, "feature"),
        t("', () => {"),
        t({ "", "\tbeforeEach(async () => {" }),
        t({ "", "\t\t" }),
        i(2, "// setup GIVEN"),
        t({ "", "\t});" }),
        t({ "", "" }),
        t({ "\tdescribe('WHEN " }),
        i(3, "action"),
        t(" is performed', () => {"),
        t({ "", "\t\tbeforeEach(async () => {" }),
        t({ "", "\t\t\t" }),
        i(4, "// setup WHEN"),
        t({ "", "\t\t});" }),
        t({ "", "" }),
        t({ "\t\tit('THEN it should " }),
        i(5, "expected outcome"),
        t("', () => {"),
        t({ "", "\t\t\t" }),
        i(0, "// assert THEN"),
        t({ "", "\t\t});" }),
        t({ "", "\t});" }),
        t({ "", "});" })
    }),

    s("then", {
        t("it('THEN it should "),
        i(1, "expected outcome"),
        t("', () => {"),
        t({ "", "\t" }),
        i(0, "// assert THEN"),
        t({ "", "});" })
    })
}

return snippets
