-- ~/.config/nvim/init.lua

-- Load core options
require('core.options')

-- Load plugin manager (lazy.nvim) and setup
require('core.lazy_setup')

-- Load keymaps
require('core.keymaps')

-- Set colorscheme immediately after lazy setup if lazy=false for theme
-- (The theme plugin spec in lua/plugins/theme.lua sets lazy=false and priority=1000)
vim.cmd.colorscheme "gruvbox"
