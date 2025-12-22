# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using lazy.nvim as the plugin manager. The config is written entirely in Lua and follows a modular structure.

## Architecture

```
init.lua                    # Entry point - loads core and lazy
lua/files/
├── core/
│   ├── init.lua           # Loads keymaps and options
│   ├── keymaps.lua        # Global keymaps (leader = space)
│   └── options.lua        # Editor options (tabs=2, relative numbers, etc.)
├── lazy.lua               # lazy.nvim bootstrap and plugin loading
├── lsp/
│   └── utils.lua          # Shared LSP utilities (capabilities, keymaps, diagnostics)
└── plugins/
    ├── init.lua           # Core dependencies (plenary, tmux-navigator)
    ├── lsp/
    │   ├── lspconfig.lua  # LSP server configurations
    │   └── mason.lua      # Mason package manager
    └── rustaceanvim.lua   # Rust-specific LSP setup (separate from lspconfig)
```

## Key Patterns

**LSP Configuration**: LSP utilities are centralized in `lua/files/lsp/utils.lua`. Both `lspconfig.lua` and `rustaceanvim.lua` use this shared module for capabilities and keymaps.

**Plugin Structure**: Each plugin file in `lua/files/plugins/` returns a lazy.nvim plugin spec table. Plugins are auto-loaded via `{ import = "files.plugins" }`.

**Formatting**: Uses conform.nvim with format-on-save. Formatters: prettier (JS/TS/web), stylua (Lua), black/isort (Python).

## Important Keymaps

- `<leader>` = Space
- `<leader>ee` - Toggle file explorer (nvim-tree)
- `<leader>ff` - Find files (Telescope)
- `<leader>fs` - Live grep (Telescope)
- `<leader>ca` - Code actions (LSP)
- `<leader>rn` - Rename symbol (LSP)
- `<leader>cr` - Cargo run (terminal)
- `<leader>cb` - Cargo build (terminal)

## LSP Servers

Configured via `vim.lsp.config()` and `vim.lsp.enable()` (native Neovim 0.11+ API):
- html, ts_ls, cssls, tailwindcss, svelte, prismals, graphql, emmet_ls, pyright, lua_ls
- Rust: handled separately by rustaceanvim plugin

## Notes

- Uses NixOS-managed packages (see timlisemer/nixos config)
- Colorscheme: nightfly with transparent background
- Terminal integration via toggleterm
