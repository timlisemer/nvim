return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = { "rust" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lsp_utils = require("files.lsp.utils")

    vim.g.rustaceanvim = {
      tools = {},
      server = {
        on_attach = function(client, bufnr)
          lsp_utils.setup_keymaps(bufnr)
        end,
        capabilities = lsp_utils.get_capabilities(),
        default_settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = { allFeatures = true },
            procMacro = { enable = true },
          },
        },
      },
      dap = {},
    }
  end,
}
