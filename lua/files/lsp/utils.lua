local M = {}

function M.get_capabilities()
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    return cmp_nvim_lsp.default_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end

function M.setup_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true, noremap = true }

  local function set(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end

  set("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references")
  set("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions")
  set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations")
  set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions")
  set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
  set("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
  set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics")
  set("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
  set("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
  set("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")
  set("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
  set("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")
end

function M.setup_diagnostics()
  local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

return M
