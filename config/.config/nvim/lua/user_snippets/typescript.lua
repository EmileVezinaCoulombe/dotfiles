local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local snippets = {
    s("gwt", {
        t("describe('GIVEN "),
        i(1, "ARRANGE"),
        t("', () => {"),
        t({ "", "\t" }),
        i(2, "ARRANGE"),
        t({ "", "\tbeforeEach(() => {" }),
        t({ "", "\t\t" }),
        i(3, "ARRANGE"),
        t({ "", "\t});" }),
        t({ "", "" }),
        t({ "\tdescribe('WHEN " }),
        i(4, "ACT"),
        t(" is called', () => {"),
        t({ "", "\t\tbeforeEach(() => {" }),
        t({ "", "\t\t\t" }),
        i(5, "ACT"),
        t({ "", "\t\t});" }),
        t({ "", "" }),
        t("\t\tit('THEN it should "),
        i(6, "ASSERT"),
        t("', () => {"),
        t({ "", "\t\t\t" }),
        t({ "expect(" }),
        i(7, "RESULT"),
        t({ ").to" }),
        i(8, "ASSERT"),
        t({ "(" }),
        i(9, "EXPECTED"),
        t({ ");" }),
        t({ "", "\t\t});" }),
        t({"", ""}),
        i(0, "IT"),
        t({ "", "\t});" }),
        t({ "", "});" })
    }),

    s("then", {
        t("it('THEN it should "),
        i(1, "ASSERT"),
        t("', () => {"),
        t({ "", "\t" }),
        t({ "expect(" }),
        i(2, "RESULT"),
        t({ ").to" }),
        i(3, "ASSERT"),
        t({ "(" }),
        i(4, "EXPECTED"),
        t({ ");" }),
        t({ "", "});" }),
        t({ "", "" }),
        i(0, "IT"),
    }),

    s("test_file", {
        t("describe('"),
        i(1, "TEST_FILE"),
        t("', () => {"),
        t({ "", "\t" }),
        i(2, "ARRANGE"),
        t({ "", "", "\tbeforeEach(() => {" }),
        t({ "", "\t\tjest.clearAllMocks();" }),
        t({ "", "\t\t" }),
        i(3, "ARRANGE"),
        t({ "", "\t});" }),
        t({ "", "", "\t" }),
        i(0, "TESTS"),
        t({ "", "});" })
    }),

    s("describe", {
        t("describe('"),
        i(1, "DESCRIBE"),
        t("', () => {"),
        t({ "", "\t" }),
        t({ "", "\t});" }),
        t({ "", "", "\t" }),
        i(0, "TESTS"),
        t({ "", "});" })
    }),
}

return snippets
