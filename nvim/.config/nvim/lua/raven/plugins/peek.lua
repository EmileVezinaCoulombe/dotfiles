return {
    -- markdown preview
    {
        -- Temporary while the pr is merged
        -- "toppair/peek.nvim",
        "Saimo/peek.nvim",
        build = "deno task --quiet build:fast",
        keys = {
            {
                "<leader>up",
                function()
                    local peek = require("peek")
                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end,
                desc = "Peek (Markdown Preview)",
            },
        },
        opts = { theme = "light", app = "browser" },
    },
}
