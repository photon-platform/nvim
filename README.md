# Photon Neovim Configuration

This repository contains a personal Neovim configuration optimized for modern development workflows, particularly focusing on Python. It leverages Lua for configuration and `lazy.nvim` for plugin management, aiming for a balance between features, performance, and maintainability.

## Objectives

*   **Modern Development Environment:** Provide a feature-rich editing experience comparable to modern IDEs, including robust code intelligence, debugging, and testing capabilities.
*   **Performance:** Utilize lazy-loading extensively via `lazy.nvim` to ensure fast startup times and responsiveness.
*   **Python Focus:** Offer first-class support for Python development, including accurate linting/formatting, type checking, debugging (`nvim-dap`), and virtual environment awareness (including `pyenv`).
*   **Maintainability:** Organize configuration logically using Lua modules, making it easier to understand, modify, and extend.
*   **Ergonomics:** Implement sensible keybindings (inspired by common practices and personal preferences) for efficient navigation and interaction.

## Features

This configuration includes a curated set of plugins managed by `lazy.nvim`:

*   **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) - Fast, declarative plugin management.
*   **Core Editor Enhancements:**
    *   [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): Advanced syntax highlighting, indentation, text objects, and code navigation.
    *   [nvim-surround](https://github.com/kylechui/nvim-surround): Easily add/change/delete surrounding pairs (quotes, brackets, etc.).
    *   [Comment.nvim](https://github.com/numToStr/Comment.nvim): Smart, context-aware commenting.
    *   [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): Git decorations in the sign column and hunk management.
*   **Language Server Protocol (LSP):**
    *   [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Core LSP configuration framework.
    *   [mason.nvim](https://github.com/williamboman/mason.nvim) & [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim): Seamless installation and management of LSP servers.
    *   [fidget.nvim](https://github.com/j-hui/fidget.nvim): UI for LSP progress notifications.
    *   Configured LSPs include `pyright`, `lua_ls`, `bashls`, `marksman`, `esbonio`, `html`, etc.
*   **Completion & Snippets:**
    *   [nvim-cmp](https://github.com/hrsh7th/nvim-cmp): Autocompletion framework.
    *   [LuaSnip](https://github.com/L3MON4D3/LuaSnip): Snippet engine.
    *   [friendly-snippets](https://github.com/rafamadriz/friendly-snippets): Collection of common snippets.
    *   Sources configured: LSP, snippets, buffer, path.
*   **Debugging (DAP):**
    *   [nvim-dap](https://github.com/mfussenegger/nvim-dap): Debug Adapter Protocol client.
    *   [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python): Python debugger integration (`debugpy`). Configured to work with `pyenv`.
    *   [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui): UI for DAP sessions (scopes, breakpoints, watches, REPL).
*   **Fuzzy Finding:**
    *   [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): Highly extendable fuzzy finder for files, buffers, grep, LSP symbols, etc.
    *   [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim): Performance boost using native FZF sorting.
*   **UI & Aesthetics:**
    *   [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim): Theme.
    *   [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim): Statusline.
    *   [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons): Filetype icons.

## Configuration Strategy

*   **Entry Point:** `init.lua` serves as the main entry point, responsible for loading core options, bootstrapping `lazy.nvim`, loading keymaps, and setting the colorscheme.
*   **Core Settings:** Basic editor settings (indentation, line numbers, search behavior, etc.) are defined in `lua/core/options.lua`.
*   **Plugin Management:** `lazy.nvim` is set up in `lua/core/lazy_setup.lua`. It loads plugin specifications from files within the `lua/plugins/` directory. Each file typically configures one plugin or a related group of plugins (e.g., `lua/plugins/lsp.lua`, `lua/plugins/dap.lua`).
*   **Keymaps:** Global and plugin-specific keymaps are defined in `lua/core/keymaps.lua`. Plugin-specific keymaps that depend on the plugin being loaded might also be defined within the plugin's configuration file (e.g., `gitsigns` uses `on_attach`, `nvim-dap` uses the `keys` table).
*   **Custom Snippets:** User-defined snippets are placed in `lua/custom-snippets/` (e.g., `lua/custom-snippets/python.lua`).

## Keymaps

A comprehensive list of custom keybindings can be found in [KEYMAPS.md](./KEYMAPS.md).

## Installation & Setup

1.  **Prerequisites:**
    *   Neovim >= 0.8 (check `nvim --version`)
    *   Git
    *   A C compiler (for Treesitter parsers, e.g., `build-essential` on Debian/Ubuntu)
    *   `make` (for `telescope-fzf-native`)
    *   `python3` and `pip`
    *   `pyenv` (optional, but recommended for managing Python versions; the DAP config attempts to detect it)
    *   A Nerd Font installed and configured in your terminal for icons and separators.
2.  **Clone the Repository:**
    ```bash
    git clone <repository_url> ~/.config/nvim
    ```
3.  **Install Python Debugger:**
    ```bash
    pip install debugpy
    ```
    *(Note: If using `pyenv`, ensure `debugpy` is installed in the Python version(s) you intend to debug).*
4.  **Launch Neovim:**
    Open Neovim (`nvim`). `lazy.nvim` should automatically bootstrap itself and install the configured plugins. You might need to restart Neovim after the initial installation.
5.  **Treesitter Parsers:** Run `:TSUpdate` inside Neovim to install/update Treesitter parsers if they weren't automatically installed.
6.  **Mason LSP/DAP Servers:** Run `:Mason` to open the Mason UI and ensure required LSP servers (`pyright`, `lua_ls`, etc.) and DAP adapters are installed. `mason-lspconfig` should handle installing the `ensure_installed` servers automatically on startup.

## Usage Notes

*   **Python Debugging:** Open a Python file and use `<leader>dp` to start debugging. See `dap_practice.py` for examples and keymap reminders. Ensure the correct `pyenv` environment is active *before* launching Neovim if you rely on `pyenv global` or `pyenv local`.
*   **LSP:** LSP features (diagnostics, hover, definition, etc.) should activate automatically for supported file types once the corresponding LSP server is installed via Mason.
*   **Telescope:** Use `<leader>f` prefixed keymaps (e.g., `<leader>ff` for files, `<leader>fg` for grep) to access Telescope pickers.
