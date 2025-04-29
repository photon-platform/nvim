-- lua/core/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key is defined in core options (e.g., vim.g.mapleader = ' ')

-- General Mappings
map('n', '<leader>ev', ':edit $MYVIMRC<CR>', { noremap = true, silent = true, desc = 'Edit init.lua' }) --  (Update path if needed)
map('n', '<leader>sv', ':source $MYVIMRC<CR>', { noremap = true, silent = true, desc = 'Source init.lua (Restart often better)' }) --
map('n', '<leader>h', ':noh<CR>', opts) -- No Highlight
map('n', '<leader>w', ':%s/\\s\\+$//e<CR>', { noremap = true, silent = true, desc = 'Trim Whitespace' }) --

-- Buffer Navigation
map('n', '<leader>n', ':bn<CR>', opts) -- Next Buffer
map('n', '<leader>p', ':bp<CR>', opts) -- Previous Buffer
map('n', '<leader>bd', ':bdelete<CR>', {noremap = true, silent = true, desc = 'Delete Buffer'}) -- Close current buffer

-- Primeagen Remaps (Examples)
map('n', 'Y', 'y$', opts) -- Yank to end of line
map({'n', 'x'}, '}', '}') -- Keep default behavior (or customize)
map({'n', 'x'}, '{', '{') -- Keep default behavior (or customize)
-- map('n', 'n', 'nzzzv', opts) -- Center on next search result
-- map('n', 'N', 'Nzzzv', opts) -- Center on previous search result

-- Telescope Mappings (Requires Telescope)
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' }) -- Find Files
map('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' }) -- Live Grep
map('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' }) -- Find Buffers
map('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' }) -- Find Help Tags
map('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind [O]ld Files'}) -- Find Recent Files (requires Telescope setup)
map('n', '<leader>ft', builtin.lsp_workspace_symbols, { desc = '[F]ind Project Sym[t]ols (LSP)' }) -- Project Symbols
map('n', '<leader>fT', builtin.lsp_document_symbols, { desc = '[F]ind Buffer Sym[T]ols (LSP)' }) -- Buffer Symbols
map('n', '<leader>fc', builtin.commands, { desc = '[F]ind [C]ommands' }) -- Find Commands
map('n', '<leader>fm', builtin.marks, { desc = '[F]ind [M]arks' }) -- Find Marks
-- map('n', '<leader>fS', builtin.snippets, { desc = '[F]ind [S]nippets' }) -- Requires telescope-snippets extension

-- Commenting Mapping (Requires Comment.nvim)
map('n', '<leader>/', function() require('Comment.api').toggle.linewise.current() end, { desc = 'Toggle Comment Line' }) --
map('v', '<leader>/', function()
    -- Special handling for visual mode toggle
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
    require('Comment.api').toggle.blockwise(vim.fn.visualmode())
  end, { desc = 'Toggle Comment Block' }) --


-- Add other custom mappings...
