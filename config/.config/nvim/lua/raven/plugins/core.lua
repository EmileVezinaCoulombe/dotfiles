return {
    { "folke/lazy.nvim",                version = "*" },
    { "eandrju/cellular-automaton.nvim" },
    { "gpanders/editorconfig.nvim" },
    { "nvim-lua/plenary.nvim",          lazy = true },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            defaults = {
                prompt_prefix = require("raven.core").icons.telescope.prompt_prefix,
                selection_caret = require("raven.core").icons.telescope.selection_caret,
                file_ignore_patterns = { ".git/**/*", "node_modules/**/*" },
            },
            extension = {
                media_files = {
                    filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf" },
                    find_cmd = "rg",
                },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                    }
                }
            },
        },
        config = function(_, opts)
            require("telescope").setup({ opts })
            require("telescope").load_extension("ui-select")
        end,
        keys = {
            {
                "<leader>,",
                "<cmd>Telescope buffers show_all_buffers=true<cr>",
                desc = "Switch Buffer",
            },
            {
                "<leader>s:",
                "<cmd>Telescope command_history<cr>",
                desc = "Command History",
            },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",  desc = "Buffers" },
            {
                "<leader><leader>",
                function()
                    require("telescope.builtin").find_files({
                        file_ignore_patterns = { "^.git/", "**/*.bru" },
                    })
                end,
                desc = "Find files (root dir)",
            },
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files({
                        hidden = true,
                        no_ignore = true,
                        file_ignore_patterns = { "^.git/" },
                    })
                end,
                desc = "Find all Files (root dir)",
            },
            {
                "<leader>sb",
                "<cmd>Telescope current_buffer_fuzzy_find<cr>",
                desc = "Buffer",
            },
            { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
            {
                "<leader>sC",
                "<cmd>Telescope command_history<cr>",
                desc = "Command History",
            },
            {
                "<leader>sd",
                "<cmd>Telescope diagnostics bufnr=0<cr>",
                desc = "Document diagnostics",
            },
            {
                "<leader>sD",
                "<cmd>Telescope diagnostics<cr>",
                desc = "Workspace diagnostics",
            },
            {
                "<leader>sg",
                function()
                    require("telescope.builtin").live_grep({
                        hidden = true,
                        no_ignore = true,
                        additional_args = { "-j1" },
                        glob_pattern = { "!.git", "!target", "!node_modules", "!**/*.png", "!**/*.jpeg", "!**/*.jpg", "!**/*.pdf" },
                    })
                end,
                desc = "Grep",
            },
            {
                "<leader>sG",
                function()
                    require("telescope.builtin").live_grep({
                        hidden = true,

                        additional_args = { "-j1" },
                        glob_pattern = { "**/*", "!.git", "!target", "!node_modules", "!**/*.png", "!**/*.jpeg", "!**/*.jpg", "!**/*.pdf" },
                    })
                end,
                desc = "Grep more",
            },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>",   desc = "Help Pages" },
            {
                "<leader>sH",
                "<cmd>Telescope highlights<cr>",
                desc = "Search Highlight Groups",
            },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>",     desc = "Key Maps" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>",   desc = "Man Pages" },
            { "<leader>sm", "<cmd>Telescope marks<cr>",       desc = "Jump to Mark" },
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
            { "<leader>sR", "<cmd>Telescope resume<cr>",      desc = "Resume last search" },
            {
                "<leader>sw",
                function()
                    require("telescope.builtin").grep_string({ word_match = "-w" })
                end,
                desc = "Word",
            },
            {
                "<leader>uC",
                function()
                    require("telescope.builtin").colorscheme({ enable_preview = true })
                end,
                desc = "Colorscheme with preview",
            },
            {
                "<leader>ss",
                "<cmd>Telescope lsp_document_symbols<cr>",
                desc = "Goto Symbol",
            },
            {
                "<leader>sS",
                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                desc = "Goto Symbol (Workspace)",
            },
        },
    },
}
