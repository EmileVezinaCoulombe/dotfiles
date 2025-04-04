return {
    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --         "MunifTanjim/nui.nvim",
    --     },
    --     opts = {
    --         window = {
    --             mappings = {
    --                 ["Z"] = "expand_all_nodes"
    --             }
    --         },
    --         filesystem = {
    --             filtered_items = {
    --                 hide_dotfiles = false,
    --                 hide_gitignored = false,
    --                 hide_by_name = {
    --                     "node_modules",
    --                 },
    --                 always_show = {
    --                     ".gitignored",
    --                 },
    --             },
    --         },
    --     },
    --     keys = {
    --         {
    --             "<leader>e",
    --             "<cmd>Neotree toggle reveal position=right reveal_force_cwd<cr>",
    --             desc = "Tree",
    --         },
    --     },
    -- },
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "nvimtree toggle window" },
            { "<leader>E", "<cmd>NvimTreeFocus<CR>",  desc = "nvimtree focus window" }
        },
        opts = {
            filters = { dotfiles = false, custom = { "^.git$" } },
            disable_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            view = {
                side = "right",
                width = {
                    min = 30,
                    max = 200,
                    padding = 1,
                },
                relativenumber = true,
                preserve_window_proportions = false,
            },
            renderer = {
                root_folder_label = false,
                highlight_git = true,
                indent_markers = { enable = true },
                icons = {
                    glyphs = {
                        default = "󰈚",
                        folder = {
                            -- default = "",
                            empty = "",
                            empty_open = "",
                            open = "",
                            symlink = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },

                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                        modified = true,
                        hidden = false,
                        diagnostics = true,
                        bookmarks = true,
                    },
                },
            },
        }
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = {},
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            -- local trouble = require("trouble")
            -- local symbols = trouble.statusline({
            --     mode = "lsp_document_symbols",
            --     groups = {},
            --     title = false,
            --     filter = { range = true },
            --     format = "{kind_icon}{symbol.name:Normal}",
            --     hl_group = "lualine_c_normal",
            -- })
            -- table.insert(opts.sections.lualine_c, {
            --     symbols.get,
            --     cond = symbols.has,
            -- })
        end,
    },
    {
        "ThePrimeagen/vim-apm",
        opts = {},
        config = function(_, opts)
            local apm = require("vim-apm")
            apm:setup(opts)
        end,
        keys = {
            {
                "<leader>um",
                function()
                    require("vim-apm"):toggle_monitor()
                end,
                desc = "vim apm",
            },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>su", "<cmd>UndotreeToggle<cr>", desc = "Undo tree toggle" },
        },
    },
    {
        "gbprod/yanky.nvim",
        opts = function()
            return {
                highlight = { timer = 100 },
            }
        end,
        keys = {
            {
                "<leader>sy",
                function()
                    require("telescope").extensions.yank_history.yank_history({})
                end,
                desc = "Open Yank History",
            },
        },
    },
    { "echasnovski/mini.nvim", version = false },
    {
        "0x00-ketsu/autosave.nvim",
        event = { "InsertLeave", "TextChanged" },
        opts = {
            prompt_message = function()
                return ""
            end,
            conditions = {
                exists = true,
                modifiable = true,
                filename_is_not = {},
                filetype_is_not = { "lua", "java" },
            },
        },
        config = function(_, opts)
            require("autosave").setup(opts)
        end,
        keys = { { "<leader>S", ":ASToggle<CR>", desc = "Toggle auto save" } },
    },
    {
        "HakonHarnes/img-clip.nvim",
        event = "BufEnter",
        opts = {},
        keys = {
            { "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            {
                "<leader>up",
                ft = "markdown",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Markdown Preview",
            },
        },
        config = function()
            vim.cmd([[do FileType]])
        end,
    },
    {
        "OXY2DEV/markview.nvim",
        enabled = false,
        lazy = false, -- Recommended
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            modes = { "n", "i", "no", "c" },
            hybrid_modes = { "i" },

            -- This is nice to have
            callbacks = {
                on_enable = function(_, win)
                    vim.wo[win].conceallevel = 2
                    vim.wo[win].concealcursor = "nc"
                end,
            },
        },
        keys = {
            { "<leader>uv", "<cmd>Markview toggle<cr>" },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
        keys = {
            { "]h",          "<cmd>Gitsigns next_hunk<cr>",       desc = "Next Hunk" },
            { "[h",          "<cmd>Gitsigns prev_hunk<cr>",       desc = "Prev Hunk" },
            { "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>",      desc = "Stage Hunk" },
            { "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>",      desc = "Reset Hunk" },
            { "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>",    desc = "Stage Buffer" },
            { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
            { "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>",    desc = "Reset Buffer" },
            { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>",    desc = "Preview Hunk" },
            {
                "<leader>ghb",
                function()
                    require("gitsigns").blame_line({ full = true })
                end,
                desc = "Blame Line",
            },
            { "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
            {
                "<leader>ghD",
                function()
                    require("gitsigns").diffthis("~")
                end,
                desc = "Diff This ~",
            },
        },
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        keys = {
            {
                "<leader>xe",
                "<cmd>Trouble diagnostics toggle filter = { severity=vim.diagnostic.severity.ERROR } <cr>",
                desc = "Diagnostics Error (Trouble)",
            },
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>ct",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "laytan/cloak.nvim",
        opts = {
            enabled = true,
            cloak_character = "*",
            cloak_length = 10,
            -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
            highlight_group = "Comment",
            patterns = {
                {
                    file_pattern = {
                        ".env*",
                    },
                    -- Match an equals sign and any character after it.
                    cloak_pattern = { "=.+", "-.+" },
                },
            },
        },
        keys = {
            { "<leader>uh", "<cmd>CloakToggle<cr>", desc = "Cloak toggle" },
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        event = {
            -- refer to `:h file-pattern` for more examples
            "BufReadPre "
            .. vim.fn.expand("~")
            .. "/OneDrive/vault/*.md",
            "BufNewFile " .. vim.fn.expand("~") .. "/OneDrive/vault/*.md",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            {
                "folke/which-key.nvim",
                opts = {
                    defaults = {
                        ["<leader>o"] = { name = "+Obsidian" },
                    },
                },
            },
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/OneDrive/vault",
                },
            },
            templates = {
                folder = "template",
                date_format = "%d-%m-%Y",
                time_format = "%H:%M",
            },
            mappings = {
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- Toggle check-boxes.
                ["<leader>ch"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
                -- Smart action depending on context, either follow link or toggle checkbox.
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                },
            },
        },
        keys = {
            { "gX",         "<cmd>ObsidianOpen<cr>",            desc = "Go to Obsidian" },
            { "<leader>oN", "<cmd>ObsidianNew<cr>",             desc = "New file" },
            { "<leader>on", "<cmd>ObsidianNewFromTemplate<cr>", desc = "New file from template" },
            {
                "<leader>on",
                mode = { "v" },
                "<cmd>ObsidianLinkNew<cr>",
                desc = "New file with link",
            },
            {
                "<leader>oe",
                mode = { "v" },
                "<cmd>ObsidianExtractNote<cr>",
                desc = "Extract to a new file",
            },
            { "gf",                "<cmd>ObsidianFollowLink<cr>",     desc = "Go to file" },
            { "<leader>o<leader>", "<cmd>ObsidianQuickSwitch<cr>",    desc = "Search file" },
            { "<leader>og",        "<cmd>ObsidianSearch<cr>",         desc = "Search Grep" },
            { "gr",                "<cmd>ObsidianBacklinks<cr>",      desc = "References" },
            { "<leader>ot",        "<cmd>ObsidianTags<cr>",           desc = "Search tags" },
            { "<leader>oi",        "<cmd>ObsidianTemplate<cr>",       desc = "Insert Template" },
            { "<leader>ol",        "<cmd>ObsidianLinks<cr>",          desc = "Serch links" },
            { "<leader>ow",        "<cmd>ObsidianWorkspace<cr>",      desc = "Workspaces" },
            -- { "<leader>p",         "<cmd>ObsidianPasteImg<cr>",       desc = "Paste clipboard image" },
            { "<leader>cr",        "<cmd>ObsidianRename<cr>",         desc = "Rename" },
            { "<leader>od",        "<cmd>ObsidianToggleCheckbox<cr>", desc = "Done" },
            { "<leader>oh",        "<cmd>ObsidianTOC<cr>",            desc = "TOC header" },
            -- { "",                  "<cmd>ObsidianLink<cr>",           desc = "" },
            -- { "",                  "<cmd>ObsidianToday<cr>",          desc = "" },
            -- { "",                  "<cmd>ObsidianTomorrow<cr>",       desc = "" },
            -- { "",                  "<cmd>ObsidianYesterday<cr>",      desc = "" },
            -- { "",                  "<cmd>ObsidianDailies<cr>",        desc = "" },
        },
    },
}
