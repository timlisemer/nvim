return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lsp_utils = require("files.lsp.utils")

    lsp_utils.setup_diagnostics()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        lsp_utils.setup_keymaps(ev.buf)
      end,
    })

    local capabilities = lsp_utils.get_capabilities()

    -- Simple servers with no custom settings
    local simple_servers = { "html", "ts_ls", "cssls", "tailwindcss", "prismals", "pyright" }
    for _, server in ipairs(simple_servers) do
      vim.lsp.config(server, { capabilities = capabilities })
    end

    -- Svelte with BufWritePost autocmd for TS/JS file change notifications
    vim.lsp.config("svelte", {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        lsp_utils.setup_keymaps(bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = vim.api.nvim_create_augroup("SvelteTsJsNotify", { clear = true }),
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            if client.name == "svelte" then
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
            end
          end,
        })
      end,
    })

    -- GraphQL with extended filetypes
    vim.lsp.config("graphql", {
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- Emmet with extended filetypes
    vim.lsp.config("emmet_ls", {
      capabilities = capabilities,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    -- Lua with Neovim-specific settings
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- Enable all servers
    vim.lsp.enable({
      "html",
      "ts_ls",
      "cssls",
      "tailwindcss",
      "svelte",
      "prismals",
      "graphql",
      "emmet_ls",
      "pyright",
      "lua_ls",
    })
  end,
}
