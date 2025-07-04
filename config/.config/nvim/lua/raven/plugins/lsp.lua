return {
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "Wansmer/symbol-usage.nvim",
        event = 'LspAttach',
        config = function()
            local SymbolKind = vim.lsp.protocol.SymbolKind
            require('symbol-usage').setup({
                ---@type lsp.SymbolKind[] Symbol kinds what need to be count (see `lsp.SymbolKind`)
                kinds = { SymbolKind.Function, SymbolKind.Method },
                ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn' `above` by default
                vt_position = 'end_of_line',
                log = { enabled = false },
                disable = { lsp = {}, filetypes = {}, cond = {} },
            })
        end,
        keys = { {
            "<leader>uu",
            function()
                require('symbol-usage').toggle_globally()
            end,
            desc = "Toggle Usages"
        } },
    },
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "SergioRibera/cmp-dotenv" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-emoji" },
            { "petertriho/cmp-git" },
            { "hrsh7th/cmp-nvim-lua" },
            { "Saecki/crates.nvim" },
            { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
            { "onsails/lspkind.nvim",                   config = {} }
        },
        -- opts = { sources = { name = "crates" } },
        opts = function()
            -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()

            return {
                default_timeout = 500,
                experimental = {
                    -- ghost_text = {
                    --     hl_group = "CmpGhostText",
                    -- },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                auto_brackets = {}, -- configure any filetype to auto add brackets
                -- completion = {
                --     completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                -- },
                -- preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<Down>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<Up>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    -- ["<tab>"] = cmp.mapping.complete(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept explicitly selected item.
                    -- ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-Tab>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-e>"] = cmp.mapping.abort(),
                }),
                sources = cmp.config.sources({
                    { name = "copilot",  group_index = 2 },
                    { name = "nvim_lsp", group_index = 2 },
                    { name = "path",     group_index = 2 },
                    { name = "luasnip",  group_index = 2 },
                    -- { name = "nvim_lsp:tailwindcss" },
                }, {
                    { name = "buffer" },
                    { name = "crates" },
                    { name = "dotenv" },
                    { name = "emoji" },
                    -- { name = "git" },
                }),
                formatting = {
                    format = require('lspkind').cmp_format({
                        mode = "symbol",
                        max_width = 50,
                        symbol_map = { Copilot = "" }
                    })
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            }
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "artemave/workspace-diagnostics.nvim",
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Uncomment whichever supported plugin(s) you use
            "nvim-tree/nvim-tree.lua",
            -- "nvim-neo-tree/neo-tree.nvim",
            -- "simonmclean/triptych.nvim"
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "j-hui/fidget.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- biome = {},
                tailwindcss = {},
                jdtls = false,
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- This is where all the LSP shenanigans live
            local set_autoformat = function(pattern, bool_val)
                vim.api.nvim_create_autocmd({ "FileType" }, {
                    pattern = pattern,
                    callback = function()
                        vim.b.autoformat = bool_val
                    end,
                })
            end

            set_autoformat({ "java" }, false)

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("raven-lsp-attach", { clear = true }),
                callback = function(event)
                    local function map(mode, lhs, rhs, k_opts)
                        vim.keymap.set(
                            mode,
                            lhs,
                            rhs,
                            vim.tbl_extend("force", { buffer = event.buf, remap = false }, k_opts)
                        )
                    end

                    map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
                    map("n", "<C-f>", function()
                        local _eslint_success, _ = pcall(vim.cmd, "EslintFixAll")
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, { desc = "Format" })
                    map("n", "<leader>cf", function()
                        local _eslint_success, _ = pcall(vim.cmd, "EslintFixAll")
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, { desc = "Format" })
                    map("n", "gd", function()
                        vim.lsp.buf.definition()
                    end, { desc = "Definition" })
                    map("n", "K", function()
                        vim.lsp.buf.hover()
                    end, { desc = "Hover" })
                    map("n", "<leader>cw", function()
                        vim.lsp.buf.workspace_symbol()
                    end, { desc = "Workspace symbol" })
                    map("n", "<leader>cd", function()
                        vim.diagnostic.open_float()
                    end, { desc = "Search diagnostic" })
                    map("n", "]d", function()
                        vim.diagnostic.goto_next()
                    end, { desc = "Next diagnostic" })
                    map("n", "[d", function()
                        vim.diagnostic.goto_prev()
                    end, { desc = "Previous diagnostic" })
                    map("n", "<leader>ca", function()
                        vim.lsp.buf.code_action()
                    end, { desc = "Code action" })
                    map('v', '<leader>ca', function()
                        vim.lsp.buf.code_action({
                            -- This will pass the current visual selection range to LSP
                            range = {
                                ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                                ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                            }
                        })
                    end, {
                        desc = 'Code Action'
                    })

                    map("n", "gr", function()
                        require("telescope.builtin").lsp_references({ reuse_win = true })
                        -- vim.lsp.buf.references({})
                    end, { desc = "References" })
                    map("n", "<leader>cr", function()
                        vim.lsp.buf.rename()
                    end, { desc = "Rename" })
                    map("i", "<C-h>", function()
                        vim.lsp.buf.signature_help()
                    end, { desc = "Signature help" })

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    --     local highlight_augroup = vim.api.nvim_create_augroup("raven-lsp-highlight", { clear = false })
                    --     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd("LspDetach", {
                    --         group = vim.api.nvim_create_augroup("raven-lsp-detach", { clear = true }),
                    --         callback = function(event2)
                    --             vim.lsp.buf.clear_references()
                    --             vim.api.nvim_clear_autocmds({ group = "raven-lsp-highlight", buffer = event2.buf })
                    --         end,
                    --     })
                    -- end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    --     map("<leader>th", function()
                    --         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    --     end, "[T]oggle Inlay [H]ints")
                    -- end
                end,
            })

            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities(),
                require('lsp-file-operations').default_capabilities()
            )

            require("lspconfig").sqlls.setup(require("raven.plugins.lsp-opts.sqlls"))
            require("lspconfig").bashls.setup({
                filetypes = { "sh", "zsh" },
            })
            require("lspconfig").yamlls.setup(require("raven.plugins.lsp-opts.yamlls"))
            require("lspconfig").jsonls.setup(require("raven.plugins.lsp-opts.jsonls"))
            require("lspconfig").lua_ls.setup({
                capabilities = capabilities,
                settings = {},
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                end,
            })
            require("lspconfig").angularls.setup({
                capabilities = capabilities,
                settings = {},
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    vim.api.nvim_set_keymap('n', '<space>xp', '', {
                        noremap = true,
                        callback = function()
                            for _, lsp_client in ipairs(vim.lsp.get_clients()) do
                                require("workspace-diagnostics").populate_workspace_diagnostics(lsp_client, 0)
                            end
                        end
                    })
                end,
            })
            require("lspconfig").basedpyright.setup({
                capabilities = capabilities,
                settings = {},
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                end,
            })
            require("lspconfig").pylyzer.setup({
                cmd = { "pylyzer", "--server" },
                capabilities = capabilities,
                settings = {}
            })
            require("lspconfig").ruff.setup({
                capabilities = capabilities,
                settings = {
                    ruff = {
                        lint = {
                            enable = true,
                        },
                        organizeImports = true,
                        fixAll = true,
                    }
                },
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    local function format_and_organize()
                        -- local params = {
                        --     command = "ruff.applyOrganizeImports",
                        --     arguments = {
                        --         {
                        --             uri = vim.uri_from_bufnr(0),
                        --             version = vim.b[bufnr].changedtick,
                        --         }
                        --     }
                        -- }
                        -- vim.lsp.buf.execute_command(params)
                        vim.lsp.buf.format({ async = false, timeout_ms = 100 })
                    end
                    vim.keymap.set('n', '<leader>cf', format_and_organize, {
                        buffer = bufnr,
                        desc = 'Format'
                    })
                end
            })
            require("lspconfig").tailwindcss.setup({
                capabilities = capabilities,
                filetypes = {
                    "css",
                    "scss",
                    "sass",
                    "postcss",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "svelte",
                    "vue",
                    "rust",
                    "rs",
                },
                init_options = {
                    userLanguages = {
                        rust = "html",
                    },
                },
            })
            require("lspconfig").ts_ls.setup({
                capabilities = capabilities,
                single_file_support = false,
                on_init = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentFormattingRangeProvider = false
                end,
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    vim.api.nvim_set_keymap('n', '<space>xp', '', {
                        noremap = true,
                        callback = function()
                            for _, lsp_client in ipairs(vim.lsp.get_clients()) do
                                require("workspace-diagnostics").populate_workspace_diagnostics(lsp_client, 0)
                            end
                        end
                    })
                end,
                init_options = {
                    hostInfo = "neovim",
                    preferences = {
                        includeCompletionsForModuleExports = true,
                        includeCompletionsForImportStatements = true,
                        importModuleSpecifierPreference = "relative",
                    },
                },
                settings = {
                    typescript = {
                        preferences = {
                            importModuleSpecifierPreference = "relative",
                            importModuleSpecifierEnding = "minimal", -- Or "js", "index" based on need
                        },
                    },
                    javascript = {
                        preferences = {
                            importModuleSpecifierPreference = "relative",
                            importModuleSpecifierEnding = "minimal",
                        },
                    },
                },
            })
            require("lspconfig").eslint.setup({
                settings = {
                    -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
                    workingDirectory = { mode = "auto" },
                },
            })
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --     callback = function(event)
            --         local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
            --         if client then
            --             local diag = vim.diagnostic.get(
            --                 event.buf,
            --                 { namespace = vim.lsp.diagnostic.get_namespace(client.id) }
            --             )
            --             if #diag > 0 then
            --                 vim.cmd("EslintFixAll")
            --             end
            --         end
            --     end,
            -- })
            vim.filetype.add({ extension = { typ = "typst" } })
            require("lspconfig").tinymist.setup({
                capabilities = capabilities,
                offset_encoding = "utf-8",
                settings = {},
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                end,
            })
            --     require("lspconfig").biome.setup({
            --         capabilities = capabilities,
            --         settings = {},
            --     })
            --     require("lspconfig").pylsp.setup({
            --         capabilities = capabilities,
            --         settings = {
            --             pylsp = {
            --                 plugins = {
            --                     -- Disable other linters/formatters as I use ruff for these
            --                     pycodestyle = { enabled = false },
            --                     mccabe = { enabled = false },
            --                     pyflakes = { enabled = false },
            --                     flake8 = { enabled = false },
            --                     autopep8 = { enabled = false },
            --                     yapf = { enabled = false },
            --
            --                     -- Enable rope
            --                     rope_completion = { enabled = false },
            --                     rope_autoimport = { enabled = false },
            --                     rope = {
            --                         enabled = false,
            --                         -- extract_method = { enabled = true },
            --                         -- extract_variable = { enabled = true },
            --                         -- inline = { enabled = true },
            --                         -- move = { enabled = true },
            --                     },
            --
            --                     -- Enable Jedi
            --                     jedi_completion = { enabled = true },
            --                     jedi_hover = { enabled = true },
            --                     jedi_references = { enabled = true },
            --                     jedi_signature_help = { enabled = true },
            --                     jedi_symbols = { enabled = true },
            --                 }
            --             }
            --
            --         },
            --         on_init = function(client)
            --             client.server_capabilities.documentFormattingProvider = false
            --             client.server_capabilities.documentFormattingRangeProvider = false
            --         end,
            --     })
        end,
    }, -- formatters
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function(_, opts)
            local nls = require("null-ls")

            opts.sources = vim.list_extend(opts.sources or {}, {
                -- Broken following none-ls switch
                -- nls.builtins.code_actions.shellcheck,
                -- nls.builtins.diagnostics.ruff,
                -- nls.builtins.diagnostics.shellcheck,
                -- nls.builtins.diagnostics.eslint,
                -- nls.builtins.diagnostics.luacheck.with({
                --     condition = function(utils)
                --         return utils.root_has_file({ ".luacheckrc" })
                --     end,
                -- }),

                -- code action
                -- require("typescript.extensions.null-ls.code-actions"),
                nls.builtins.code_actions.gitsigns,
                nls.builtins.code_actions.refactoring,
                -- diagnostics
                -- nls.builtins.diagnostics.ruff,
                nls.builtins.diagnostics.fish,
                nls.builtins.diagnostics.markdownlint,
                nls.builtins.diagnostics.selene.with({
                    condition = function(utils)
                        return utils.root_has_file({ "selene.toml" })
                    end,
                }),
                -- nls.builtins.diagnostics.mypy.with({
                --     extra_args = {
                --         "--python-executable",
                --         require("raven.utils").venv_python_path,
                --     },
                -- }),
                nls.builtins.diagnostics.sqlfluff.with({
                    extra_args = { "--dialect", "postgres" },
                }),
                -- formatting
                -- nls.builtins.formatting.biome.with({
                --     filetypes = {
                --         "javascript",
                --         "javascriptreact",
                --         "json",
                --         "jsonc",
                --         "typescript",
                --         "typescriptreact",
                --         "css",
                --     },
                --     args = {
                --         "check",
                --         "--write",
                --         "--unsafe",
                --         "--formatter-enabled=true",
                --         "--organize-imports-enabled=true",
                --         "--skip-errors",
                --         "--stdin-file-path=$FILENAME",
                --     },
                -- }),
                nls.builtins.formatting.prettierd,
                nls.builtins.formatting.fish_indent,
                nls.builtins.formatting.shfmt,
                nls.builtins.formatting.stylua,
                -- nls.builtins.formatting.ruff,
                nls.builtins.formatting.sql_formatter.with({
                    extra_args = { "--config", '{"tabWidth": 4}' },
                }),
                -- nls.builtins.formatting.rustfmt,
                nls.builtins.formatting.csharpier.with({
                    condition = function(utils)
                        return utils.root_has_file({ ".csharpierrc.json" })
                    end,
                }),
                nls.builtins.formatting.stylua.with({
                    condition = function(utils)
                        return utils.root_has_file({ "stylua.toml" })
                    end,
                }),
            })
            opts.should_attach = function(bufnr)
                -- Get filetype of the buffer
                local ft = vim.bo[bufnr].filetype
                -- Get the full path of the buffer
                local fname = vim.api.nvim_buf_get_name(bufnr)

                -- Don't attach to Java files or files in Java projects
                return ft ~= "java" and not vim.fn.filereadable(vim.fn.getcwd() .. "/pom.xml")
            end

            opts.condition = function(utils)
                return not utils.root_has_file("pom.xml") and vim.bo.filetype ~= "java"
            end
            return opts
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        -- event = { "BufReadPre", "BufNewFile" },
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        config = function(_, opts)
            local conf = vim.tbl_deep_extend("keep", opts, {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason").setup(conf)

            -- require("mason-tool-installer").setup({
            --     -- ensure_installed = {
            --     --     "java-debug-adapter",
            --     --     "java-test",
            --     --     "codelldb",
            --     -- }
            -- })

            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities(),
                require('lsp-file-operations').default_capabilities()
            )

            require("mason-null-ls").setup({
                automatic_installation = false,
                ensure_installed = {
                    "actionlint",
                    "stylua",
                    "shfmt",
                    "sqlfluff",
                    "markdownlint",
                    "selene",
                    "luacheck",
                    "shellcheck",
                    "rustfmt",
                    "autoflake",
                    "prettierd",
                    "sql_formatter",
                },
            })
            require("mason-lspconfig").setup({
                automatic_enable = false,
                automatic_installation = true,
                ensure_installed = {
                    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
                    "bashls",
                    "cssls",
                    "eslint",
                    "html",
                    -- "biome",
                    "angularls",
                    "jsonls",
                    "jdtls",
                    "lua_ls",
                    "powershell_es",
                    "ruff",
                    -- "pylsp",
                    "basedpyright",
                    "sqlls",
                    "tailwindcss",
                    "ts_ls",
                    "tinymist",
                    "yamlls",
                    "openscad_lsp",
                }
            })
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            { "mfussenegger/nvim-dap" },
            { "folke/which-key.nvim" },
        },
        ft = { "java" },
        keys = {
            { "<leader>cC",  ft = { "java" }, function() require("jdtls").compile() end,                       desc = "Compile" },
            { "<leader>cx",  ft = { "java" }, desc = "+extract" },
            { "<leader>cxv", ft = { "java" }, function() require("jdtls").extract_variable_all() end,          desc = "Extract Variable" },
            { "<leader>cxc", ft = { "java" }, function() require("jdtls").extract_constant() end,              desc = "Extract Constant" },
            { "gs",          ft = { "java" }, function() require("jdtls").super_implementation() end,          desc = "Goto Super" },
            { "gS",          ft = { "java" }, function() require("jdtls.tests").goto_subjects() end,           desc = "Goto Subjects" },
            { "<leader>co",  ft = { "java" }, function() require("jdtls").organize_imports() end,              desc = "Organize Imports" },
            -- Visual mode mappings
            { "<leader>cxm", ft = { "java" }, [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],     desc = "Extract Method",   mode = "v" },
            { "<leader>cxv", ft = { "java" }, [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]], desc = "Extract Variable", mode = "v" },
            { "<leader>cxc", ft = { "java" }, [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],   desc = "Extract Constant", mode = "v" },
            -- Test mappings
            { "<leader>t",   desc = "+test" },
            {
                "<leader>tt",
                ft = { "java" },
                function()
                    require("jdtls.dap").test_class()
                end,
                desc = "Run All Test"
            },
            {
                "<leader>tr",
                ft = { "java" },
                function()
                    require("jdtls.dap").test_nearest_method()
                end,
                desc = "Run Nearest Test"
            },
            { "<leader>tT", ft = { "java" }, function() require("jdtls.dap").pick_test() end, desc = "Run Test" },
        },
    },
}
