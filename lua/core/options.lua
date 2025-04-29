-- ~/.config/nvim/lua/core/options.lua

-- Essential for Lua themes
vim.opt.termguicolors = true
-- Set background early
vim.o.background = "dark"

-- Basic Editor Settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.shiftwidth = 2        -- Tabs are 2 spaces
vim.opt.tabstop = 2         -- Tabs are 2 spaces
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.autoindent = true     -- Auto-indent new lines
vim.opt.ignorecase = true     -- Ignore case in search
vim.opt.smartcase = true      -- Override ignorecase if search pattern has uppercase
vim.opt.incsearch = true      -- Incremental search
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.list = true           -- Show invisible characters
vim.opt.listchars = 'tab:!·,trail:·' -- Define invisible characters

-- Enable filetype detection, plugins, and indentation
vim.cmd("filetype plugin indent on") --
-- Enable syntax highlighting (Treesitter will handle this more robustly)
vim.cmd("syntax on") --

-- Set leader key (example: Space) - Place this *before* any mappings using <leader>
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- More options...
