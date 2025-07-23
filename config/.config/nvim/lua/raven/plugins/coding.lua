local function getMainBrach()
    local root_dir = require("raven.utils").get_root()
    -- Use % for special characters ^$()%.[]*+-?) ex: https://www.lua.org/manual/5.1/manual.html#pdf-string.format
    if string.find(root_dir, "projet-old") then
        return "master"
    end
    return "main"
end

local function getDevBrach()
    local root_dir = require("raven.utils").get_root()
    -- Use % for special characters ^$()%.[]*+-?) ex: https://www.lua.org/manual/5.1/manual.html#pdf-string.format
    if string.find(root_dir, "projet-old") then
        return "dev"
    end
    return "develop"
end

return {
    -- AI
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot_cmp").setup()
            -- they can interfere with completions properly appearing in copilot-cmp.
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end
    },
    {
        "zbirenbaum/copilot-cmp",
    },
    {
        "EmileVezinaCoulombe/avante.nvim",
        branch = "fix/llma-index-persist-dir",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        opts = {
            mode = "agentic",
            provider = 'copilot',
            -- provider = 'ollama',
            providers = {
                copilot = {
                    -- model = "claude-sonnet-4"
                    model = "gpt-4o"
                },
                ollama = {
                    model = "deepseek-r1:1.5b",
                },
                ollama_rag = {
                    __inherited_from = "ollama",
                    model = "gemma3n:latest",
                },
                ollama_embed = {
                    __inherited_from = "ollama",
                    model = "bge-m3:latest",
                },
            },
            rag_service = {
                enabled = true,
                host_mount = os.getenv("HOME"),
                runner = "docker",
                llm = {
                    provider = "ollama",
                    model = "deepseek-r1:8b",
                    endpoint = "http://host.docker.internal:11434",
                    api_key = "",
                    extra = nil,
                },
                embed = {
                    provider = "ollama",
                    model = "bge-m3:latest",
                    endpoint = "http://host.docker.internal:11434",
                    api_key = "",
                    extra = {
                        embed_batch_size = 10,
                    },
                }
            },
            hints = { enabled = false },
            web_search_engine = {
                provider = 'google',
            },
            selector = {
                exclude_auto_select = { "NvimTree" },
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        keys = {
            {
                "<leader>a+",
                function()
                    local tree_ext = require("avante.extensions.nvim_tree")
                    tree_ext.add_file()
                end,
                desc = "Select file in NvimTree",
                ft = "NvimTree",
            },
            {
                "<leader>a-",
                function()
                    local tree_ext = require("avante.extensions.nvim_tree")
                    tree_ext.remove_file()
                end,
                desc = "Deselect file in NvimTree",
                ft = "NvimTree",
            },
        },
        dependencies = {
            "zbirenbaum/copilot.lua",
            -- Required
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick",         -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua",              -- for file_selector provider fzf
            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },

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
            { "<leader>gb", desc = "+Branche changes" },
            { "<leader>gc", desc = "+Branche commits" },
            {
                "<leader>gbm",
                "<cmd>DiffviewOpen origin/" .. getMainBrach() .. "...HEAD --imply-local<cr>",
                desc = "DiffView Branche changes (main)",
            },
            {
                "<leader>gbd",
                "<cmd>DiffviewOpen origin/" .. getDevBrach() .. "...HEAD --imply-local<cr>",
                desc = "DiffView Branche changes (dev)",
            },
            {
                "<leader>gcm",
                "<cmd>:DiffviewFileHistory --range=origin/" .. getMainBrach() .. "...HEAD --right-only --no-merges<cr>",
                desc = "DiffView Branche commits (main)",
            },
            {
                "<leader>gcd",
                "<cmd>:DiffviewFileHistory --range=origin/" .. getDevBrach() .. "...HEAD --right-only --no-merges<cr>",
                desc = "DiffView Branche commits (dev)",
            },
            { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "DiffView Current changes" },
            { "<leader>g%", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
        },
    },
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", "<cmd>Git<cr>", desc = "Status" },
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
    -- {
    --     "harrisoncramer/gitlab.nvim",
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "sindrets/diffview.nvim",
    --         "stevearc/dressing.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
    --     config = function()
    --         require("gitlab").setup()
    --     end,
    --     keys = {
    --         { "<leader>gm",   desc = "+MR",                                                               mode = { "n", "v" } },
    --         { "<leader>gmh",  "<cmd>h gitlab.nvim.api<cr>",                                               desc = "Gitlab help" },
    --         { "<leader>gml",  function() require("gitlab").choose_merge_request() end,                    desc = "MR list" },
    --
    --
    --         { "<leader>gmo",  function() require("gitlab").open_in_browser() end,                         desc = "MR open in browser" },
    --         { "<leader>gmr",  function() require("gitlab").review() end,                                  desc = "MR review" },
    --         { "<leader>gmR",  function() require("gitlab").close_review() end,                            desc = "MR close review" },
    --
    --         { "<leader>gmA",  function() require("gitlab").approve() end,                                 desc = "MR approve" },
    --         { "<leader>gmc",  function() require("gitlab").create_comment() end,                          desc = "MR comment single line",               mode = { "n" } },
    --         { "<leader>gmc",  function() require("gitlab").create_multiline_comment() end,                desc = "MR comment lines",                     mode = { "v" } },
    --         { "<leader>gmS",  function() require("gitlab").create_comment_suggestion() end,               desc = "MR suggestion",                        mode = { "v" } },
    --         { "<leader>gm]",  function() require("gitlab").move_to_discussion_tree_from_diagnostic() end, desc = "MR move to discussion from diagnostic" },
    --         { "<leader>gmn",  function() require("gitlab").create_note() end,                             desc = "MR note" },
    --         { "<leader>gmp",  function() require("gitlab").publish_all_drafts() end,                      desc = "MR publish draft notes" },
    --
    --
    --         { "<leader>gms",  desc = "+State" },
    --         { "<leader>gmss", function() require("gitlab").state() end,                                   desc = "MR state" },
    --         { "<leader>gmsS", function() require("gitlab").summary() end,                                 desc = "MR summary" },
    --         { "<leader>gmsr", function() require("gitlab").refresh_data() end,                            desc = "MR refresh" },
    --         { "<leader>gmsp", function() require("gitlab").pipeline() end,                                desc = "MR pipeline" },
    --         { "<leader>gmsd", function() require("gitlab").toggle_discussions() end,                      desc = "MR toggle discussion" },
    --         { "<leader>gmsD", function() require("gitlab").toggle_draft_mode() end,                       desc = "MR toggle draft" },
    --
    --         { "<leader>gma",  desc = "+Add" },
    --         { "<leader>gmaa", function() require("gitlab").add_assignee() end,                            desc = "MR add assignee" },
    --         { "<leader>gmar", function() require("gitlab").add_reviewer() end,                            desc = "MR add reviewer" },
    --         { "<leader>gmal", function() require("gitlab").add_label() end,                               desc = "MR add lable" },
    --
    --         { "<leader>gmd",  desc = "+Delete" },
    --         { "<leader>gmda", function() require("gitlab").delete_assignee() end,                         desc = "MR delete assignee" },
    --         { "<leader>gmdr", function() require("gitlab").delete_reviewer() end,                         desc = "MR delete reviewer" },
    --         { "<leader>gmdl", function() require("gitlab").delete_label() end,                            desc = "MR delete lable" },
    --
    --         { "<leader>gmm",  desc = "+Merge" },
    --         { "<leader>gmmM", function() require("gitlab").merge() end,                                   desc = "MR merge" },
    --         {
    --             "<leader>gmmd",
    --             function()
    --                 require("gitlab").create_mr({
    --                     target = getDevBrach(),
    --                     delete_branch = true,
    --                     squash = true,
    --                     template_file =
    --                     "feature.md"
    --                 })
    --             end,
    --             desc = "MR create mr (dev)"
    --         },
    --         {
    --             "<leader>gmmm",
    --             function()
    --                 require("gitlab").create_mr({
    --                     target = getMainBrach(),
    --                     delete_branch = true,
    --                     squash = true,
    --                     template_file =
    --                     "feature.md"
    --                 })
    --             end,
    --             desc = "MR create mr (main)"
    --         },
    --     }
    -- },
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
                adapter = require('rustaceanvim.config').get_codelldb_adapter(
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
    {
        "kopecmaciej/vi-mongo.nvim",
        config = function()
            require("vi-mongo").setup()
        end,
        cmd = { "ViMongo" },
        keys = {
            { "<leader>um", "<cmd>ViMongo<cr>", desc = "ViMongo" }
        }
    }
}
