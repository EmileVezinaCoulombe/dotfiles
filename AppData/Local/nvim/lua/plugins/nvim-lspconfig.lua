return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      format = { timeout_ms = 50000 },
      autoformat = false,
      diagnostics = { virtual_text = false },
      servers = {
        angularls = {},
        eslint = {},
        pyright = {
          root_dir = function()
            return require("lazyvim.util").get_root()
          end,
        },
      },
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      setup = {
        angularls = function(_, opts)
          opts.on_attach = function(client, _)
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.foldingRangeProvider = false
          end
        end,
        eslint = function()
          require("lazyvim.util").on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
    setup = function(plugins, opts)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("lspconfig").pyright.setup({ capabilities = capabilities }) --  server = opts
      require("lspconfig").angularls.setup({ capabilities = capabilities }) --  server = opts
    end,
  },
}
