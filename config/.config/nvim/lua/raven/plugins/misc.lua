return {
    { "eandrju/cellular-automaton.nvim" },
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "ibhagwan/fzf-lua",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            ---@type string
            arg = "leetcode.nvim",

            ---@type lc.lang
            lang = "python3",

            ---@type boolean
            logging = true,

            injector = { ---@type table<lc.lang, lc.inject>
                ["python3"] = {
                    before = true
                },
                ["cpp"] = {
                    before = { "#include <bits/stdc++.h>", "using namespace std;" },
                    after = "int main() {}",
                },
                ["java"] = {
                    before = "import java.util.*;",
                },
            },

            ---@type lc.picker
            picker = { provider = "telescope" },

            keys = {
                toggle = { "q" }, ---@type string|string[]
                confirm = { "<CR>" }, ---@type string|string[]

                reset_testcases = "r", ---@type string
                use_testcase = "U", ---@type string
                focus_testcases = "H", ---@type string
                focus_result = "L", ---@type string
            },

            ---@type boolean
            image_support = false,
        },
    },
    keys = {
        {"<leader>p", desc = "+practice"},
        {"<leader>pc", desc = "Practice coding"},
        {"<leader>pcc", "<cmd>Leet menue<cr>", desc = "Menu"},
        {"<leader>pcq", "<cmd>Leet exit<cr>", desc = "Quit"},
        {"<leader>pci", "<cmd>Leet info<cr>", desc = "Info"},
        {"<leader>pct", "<cmd>Leet <tab><cr>", desc = "Tabs"},
        {"<leader>pcl", "<cmd>Leet lang<cr>", desc = "Lang"},
        {"<leader>pcr", "<cmd>Leet run<cr>", desc = "Run"},
        {"<leader>pcs", "<cmd>Leet submit<cr>", desc = "Submit"},
        {"<leader>pcp", "<cmd>Leet list<cr>", desc = "Problems"},
        {"<leader>pco", "<cmd>Leet open<cr>", desc = "Open"},
        {"<leader>pcR", "<cmd>Leet reset<cr>", desc = "Reset"},
        {"<leader>pcI", "<cmd>Leet inject<cr>", desc = "Inject"},
        {"<leader>pcd", "<cmd>Leet desc toggle<cr>", desc = "Description toggle"},
    }
}
