---@class RavenConfig
local M = {
    -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
    ---@type integer
    light_start_hour = 5,
    ---@type integer
    light_stop_hour = 19,
    ---@type table
    day_colorscheme = {
        ---@type string|fun()
        name = "catppuccin-macchiato",
        ---@type boolean
        is_light = false,
    },

    ---@type table
    night_colorscheme = {
        ---@type string|fun()
        name = "kanagawa",
        ---@type boolean
        is_light = false,
    },

    spec = {
        { import = "raven.plugins" },
        { import = "raven.plugins.coding" },
        { import = "raven.plugins.misc" },
        { import = "raven.plugins.test" },
        change_detection = {
            enabled = true,
            notify = false,
        },
        checker = { enabled = false },
    },

    icons = {
        telescope = {
            prompt_prefix = " ",
            selection_caret = " ",
        },
        indent = {
            char = "│",
        },
        dap = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
        },
        diagnostics = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
        },
        git = { added = " ", modified = " ", removed = " " },
        kinds = {
            Array = " ",
            Boolean = " ",
            Class = " ",
            Color = " ",
            Constant = " ",
            Constructor = " ",
            Copilot = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Folder = " ",
            Function = " ",
            Interface = " ",
            Key = " ",
            Keyword = " ",
            Method = " ",
            Module = " ",
            Namespace = " ",
            Null = " ",
            Number = " ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            Reference = " ",
            Snippet = " ",
            String = " ",
            Struct = " ",
            Text = " ",
            TypeParameter = " ",
            Unit = " ",
            Value = " ",
            Variable = " ",
        },
    },
}

function M.setup()
    require("raven.config.options")

    require("lazy").setup({ spec = M.spec })
    M.load_colorscheme()

    require("raven.config.autocmds")
    require("raven.config.keymaps")

    -- TODO: 2 times ?
    require("raven.config.options")
end

function M.load_colorscheme()
    local function watch_colorscheme(is_init)
        local function update_colorscheme(is_light, colorscheme)
            if is_light then
                vim.opt.background = "light"
                vim.cmd("set background=light")
            else
                vim.opt.background = "dark"
                vim.cmd("set background=dark")
            end

            if type(colorscheme) == "function" then
                colorscheme()
            else
                vim.cmd.colorscheme(colorscheme)
            end
        end

        local hr = tonumber(os.date("%H", os.time()))
        local is_light_time = hr >= M.light_start_hour and hr < M.light_stop_hour

        if is_init or vim.g.colors_name == M.day_colorscheme.name or vim.g.colors_name == M.night_colorscheme.name then
            if M.day_colorscheme.name ~= vim.g.colors_name and is_light_time then
                update_colorscheme(M.day_colorscheme.is_light, M.day_colorscheme.name)
            end

            if M.night_colorscheme.name ~= vim.g.colors_name and not is_light_time then
                update_colorscheme(M.night_colorscheme.is_light, M.night_colorscheme.name)
            end
        end
    end

    watch_colorscheme(true)
    vim.loop.new_timer():start(
        0,
        10000,
        vim.schedule_wrap(function()
            watch_colorscheme(false)
        end)
    )
end

return M
