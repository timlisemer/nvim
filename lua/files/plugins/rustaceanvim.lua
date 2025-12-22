return {
  "mrcjkb/rustaceanvim",
  version = "^4",
  ft = { "rust" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lsp_utils = require("files.plugins.lsp.utils")

    vim.g.rustaceanvim = {
      tools = {},
      server = {
        on_attach = function(client, bufnr)
          lsp_utils.setup_keymaps(bufnr)
        end,
        capabilities = lsp_utils.get_capabilities(),
        default_settings = {
          ["rust-analyzer"] = {},
        },
      },
      dap = {},
    }
  end,
}
