local function getMainBrach()
    local root_dir = require("raven.utils").get_root()
    -- Use % for special characters ^$()%.[]*+-?) ex: https://www.lua.org/manual/5.1/manual.html#pdf-string.format
    if string.find(root_dir, "projet2023%-eq05") then
        return "develop"
    end
    return "main"
end

return {
    -- auto pairs
    {
        "echasnovski/mini.pairs",
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },
    {
        "echasnovski/mini.surround",
        config = function(_, opts)
            require("mini.surround").setup(opts)
        end,
    },
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "echasnovski/mini.comment",
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    },
    {
        "linux-cultist/venv-selector.nvim",
        cmd = "VenvSelect",
        opts = { name = { "venv", ".venv", "env", ".env" } },
        keys = {
            { "<leader>cp", "<cmd>:VenvSelect<cr>", desc = "Select python VirtualEnv" },
        },
    },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter-textobjects" },
    },
    {
        "sindrets/diffview.nvim",
        opts = {
            default_args = {
                DiffviewOpen = { "--imply-local" },
                DiffviewFileHistory = { "--imply-local" },
            },
        },
        keys = {
            {
                "<leader>gb",
                "<cmd>DiffviewOpen origin/" .. getMainBrach() .. "...HEAD --imply-local<cr>",
                desc = "DiffView Branche changes",
            },
            {
                "<leader>gB",
                "<cmd>:DiffviewFileHistory --range=origin/" .. getMainBrach() .. "...HEAD --right-only --no-merges<cr>",
                desc = "DiffView Branche commits",
            },
            { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "DiffView Current changes" },
            { "<leader>g%", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
        },
    },
    {
        "tpope/vim-fugitive",
        keys = {
            {"<leader>gs", "<cmd>Git<cr>", desc = "Status" },
        }
    },
    {
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
            {
                "folke/which-key.nvim",
                opts = {
                    defaults = {
                        ["<leader>go"] = { name = "+octo" },
                    },
                },
            },
        },
        keys = {
            { "<leader>sp",  "<cmd>Octo pr list<cr>",         desc = "Pr git" },
            { "<leader>si",  "<cmd>Octo issue list<cr>",      desc = "Issues git" },
            { "<leader>gor", "<cmd>Octo review start<cr>",    desc = "Review start pr" },
            { "<leader>goR", "<cmd>Octo review start<cr>",    desc = "Review resume pr" },
            { "<leader>goc", "<cmd>Octo review commit<cr>",   desc = "Review commit pr" },
            { "<leader>goC", "<cmd>Octo review comments<cr>", desc = "Review comments pr" },
            { "<leader>gos", "<cmd>Octo review submit<cr>",   desc = "Review submit pr" },
        },
        opts = {},
    },
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- optional
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            -- configuration goes here
        },
    },
    {
        "saecki/crates.nvim",
        dependencies = {
            {
                "folke/which-key.nvim",
                opts = {
                    defaults = {
                        ["<leader>C"] = { name = "+Crates" },
                    },
                },
            },
        },
        config = function()
            require("crates").setup({
                popup = {
                    keys = {
                        hide = { "q", "<esc>" },
                        open_url = { "<cr>" },
                        select = { "<cr>" },
                        select_alt = { "s" },
                        toggle_feature = { "<cr>" },
                        copy_value = { "yy" },
                        goto_item = { "gd", "K", "<C-LeftMouse>" },
                        jump_forward = { "<c-i>" },
                        jump_back = { "<c-o>", "<C-RightMouse>" },
                    },
                },
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
        keys = {
            {
                "<leader>Ct",
                function()
                    require("crates").toggle()
                end,
                desc = "Toggle",
            },
            {
                "<leader>Cr",
                function()
                    require("crates").reload()
                end,
                desc = "Reload",
            },
            {
                "<leader>Cv",
                function()
                    require("crates").show_versions_popup()
                end,
                desc = "Show versions popup",
            },
            {
                "<leader>Cf",
                function()
                    require("crates").show_features_popup()
                end,
                desc = "Show features popup",
            },
            {
                "<leader>Cd",
                function()
                    require("crates").show_dependencies_popup()
                end,
                desc = "Show dependencies popup",
            },
            {
                "<leader>Cu",
                function()
                    require("crates").update_crate()
                end,
                desc = "Update crate",
            },
            {
                "<leader>Cu",
                function()
                    require("crates").update_crates()
                end,
                desc = "Update crates",
            },
            {
                "<leader>Ca",
                function()
                    require("crates").update_all_crates()
                end,
                desc = "Update all crates",
            },
            {
                "<leader>CU",
                function()
                    require("crates").upgrade_crate()
                end,
                desc = "Upgrade crate",
            },
            {
                "<leader>CU",
                function()
                    require("crates").upgrade_crates()
                end,
                desc = "Upgrade crates",
            },
            {
                "<leader>Cx",
                function()
                    require("crates").expand_plain_crate_to_inline_table()
                end,
                desc = "Expand plain crate to inline table",
            },
            {
                "<leader>CX",
                function()
                    require("crates").extract_crate_into_table()
                end,
                desc = "Extract crate into table",
            },
            {
                "<leader>CH",
                function()
                    require("crates").open_homepage()
                end,
                desc = "Open homepage",
            },
            {
                "<leader>CR",
                function()
                    require("crates").open_repository()
                end,
                desc = "Open repository",
            },
            {
                "<leader>CD",
                function()
                    require("crates").open_documentation()
                end,
                desc = "Open documentation",
            },
            {
                "<leades>CC",
                function()
                    require("crates").open_crates_io()
                end,
                desc = "Open crates io",
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        require = { "nvim-dap" },
        ft = { "rust" },
        opts = {
            server = {
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "<leader>cR", function()
                        vim.cmd.RustLsp("codeAction")
                    end, { desc = "Code Action", buffer = bufnr })
                    vim.keymap.set("n", "<leader>dr", function()
                        vim.cmd.RustLsp("debuggables")
                    end, { desc = "Rust Debuggables", buffer = bufnr })
                end,
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            buildScripts = {
                                enable = true,
                            },
                        },
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                                leptos_macro = {
                                    "component",
                                    "server",
                                },
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)

            opts.dap = {
                adapter =  require('rustaceanvim.config').get_codelldb_adapter(
                    "/home/emile/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
                    "/home/emile/.local/share/nvim/mason/packages/codelldb/extension/lldb/bin/lldb"
                ),
            }

            vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
        end,
        keys = {
            { "<leader>dd", "<cmd>RustLsp debuggables<cr>",  desc = "Search Debug target" },
            { "<leader>dD", "<cmd>RustLsp debug<cr>",        desc = "Debug target" },
            { "<leader>ce", "<cmd>RustLsp runnables<cr>",    desc = "Search Executables" },
            { "<leader>te", "<cmd>RustLsp testables<cr>",    desc = "Search tests Executables" },
            { "<leader>cM", "<cmd>RustLsp expandMacro<cr>",  desc = "Expand Macro" },
            { "<leader>cD", "<cmd>RustLsp explainError<cr>", desc = "Explain diagnostic" },
            { "<leader>cc", "<cmd>RustLsp flyCheck<cr>",     desc = "Check code" },
            { "<leader>cv", "<cmd>RustLsp view mir<cr>",     desc = "View Mir" },
            { "<leader>cV", "<cmd>RustLsp view hir<cr>",     desc = "View Hir" },
        },
    },
}
