Okay, here is a consolidated set of instructions for setting up your Neovim configuration files based on the recommendations in the "Neovim Configuration Plan" document.

This guide focuses on using `init.lua` for configuration and `lazy.nvim` for plugin management.

### 1. Configuration Foundation (`init.lua`)

Neovim uses `$XDG_CONFIG_HOME/nvim/init.lua` (typically `~/.config/nvim/init.lua`) for Lua-based configuration.

**Translating `vimrc` Settings to `init.lua`:**

* `set option=value` becomes `vim.opt.option = value` (e.g., `vim.opt.shiftwidth = 2`).
* Boolean options use `true`/`false` (e.g., `vim.opt.number = true`).
* Global variables (`let g:myvar = value`) become `vim.g.myvar = value`.
* Execute Vim commands with `vim.cmd("command")` or `vim.cmd([[... vimscript ...]])` for multi-line commands.
* Enable true color support early: `vim.opt.termguicolors = true`.
* Set background (needed for themes): `vim.o.background = "dark"`.

**Example Basic Settings (`init.lua` or a separate settings file like `lua/core/options.lua`):**

```lua
-- ~/.config/nvim/init.lua or sourced file

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

-- Load plugin manager (lazy.nvim) and keymaps next
-- require('core.lazy_setup') -- Assuming lazy setup is in lua/core/lazy_setup.lua
-- require('core.keymaps') -- Assuming keymaps are in lua/core/keymaps.lua
```

### 2. Plugin Management (`lazy.nvim`)

`lazy.nvim` is the recommended plugin manager for features like lazy loading, dependency management, and a user-friendly interface.

**Bootstrap `lazy.nvim`:**

Add the following bootstrap code near the beginning of your `init.lua` (or in a dedicated file like `lua/core/lazy_setup.lua` that `init.lua` requires):

```lua
-- ~/.config/nvim/init.lua or lua/core/lazy_setup.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
```

**Setup `lazy.nvim`:**

Call `require("lazy").setup()` after the bootstrap code, pointing it to your plugin specifications. It's common practice to organize plugin specs into separate files under `lua/plugins/`.

```lua
-- ~/.config/nvim/init.lua or lua/core/lazy_setup.lua (after bootstrap)

require("lazy").setup("plugins", {
  -- Optional lazy.nvim configuration options here
  checker = { enabled = true }, -- Check for updates automatically
  performance = {
    rtp = {
      -- Use compiled loader cache
      disabled_plugins = {
         -- List plugins you want to disable loading (rarely needed)
      },
    },
  },
})

-- Load colorscheme immediately after lazy setup if lazy=false for theme
vim.cmd.colorscheme "gruvbox"
```

### 3. Core Plugin Configurations (Examples)

Place the following configurations into separate files within `lua/plugins/` (e.g., `lua/plugins/lsp.lua`, `lua/plugins/treesitter.lua`, etc.). `lazy.nvim` will automatically load them if you use `require("lazy").setup("plugins")`.

**A. LSP Configuration (`lua/plugins/lsp.lua`)**

* Uses `nvim-lspconfig` to manage LSP settings.
* Uses `mason.nvim` and `mason-lspconfig.nvim` to install and integrate LSP servers.
* Includes `cmp-nvim-lsp` for completion capabilities and `fidget.nvim` for status updates.

```lua
-- lua/plugins/lsp.lua
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- Mason installs servers 
      'williamboman/mason-lspconfig.nvim', -- Integrates mason and lspconfig 
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP status updates 
      'hrsh7th/nvim-cmp', -- Required for cmp capabilities 
      'hrsh7th/cmp-nvim-lsp', -- LSP completion source 
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities() -- 

      -- Keymaps and settings on LSP attach
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- 
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true, desc = "LSP" }

        map('n', 'gd', vim.lsp.buf.definition, opts) -- 
        map('n', 'K', vim.lsp.buf.hover, opts) -- 
        map('n', 'gi', vim.lsp.buf.implementation, opts) -- 
        map('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- 
        map('n', '<leader>rn', vim.lsp.buf.rename, opts) -- 
        map('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- 
        map('n', 'gr', vim.lsp.buf.references, opts) -- 
        map('n', '<leader>ld', vim.diagnostic.open_float, opts) -- Show line diagnostics 
        map('n', '[d', vim.diagnostic.goto_prev, opts) -- 
        map('n', ']d', vim.diagnostic.goto_next, opts) -- 

        -- Optional: Format on save
        if client.supports_method('textDocument/formatting') then -- 
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ async = true, bufnr = bufnr }) end, -- 
          })
        end
      end

      -- Setup servers via mason-lspconfig
      require('mason-lspconfig').setup({
        ensure_installed = { -- Add the LSPs you need 
          'pyright', -- Recommended Python LSP 
          'bashls',
          'lua_ls',
          'marksman', -- Markdown LSP 
          'ltex', -- Optional: Markdown/RST Grammar/Style 
          'esbonio', -- RST/Sphinx LSP 
          'html', -- For Jinja2 
         },
         handlers = {
           -- Default handler using capabilities and on_attach
           function(server_name)
             lspconfig[server_name].setup {
               capabilities = capabilities,
               on_attach = on_attach,
             }
           end,
           -- Custom setup for lua_ls (example)
           ["lua_ls"] = function()
             lspconfig.lua_ls.setup {
               capabilities = capabilities,
               on_attach = on_attach,
               settings = { -- Custom settings 
                 Lua = {
                   runtime = { version = 'LuaJIT' },
                   diagnostics = { globals = { 'vim' } },
                   workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                   telemetry = { enable = false },
                 }
               }
             }
           end,
            -- Add custom setups for other servers if needed (e.g., pyright virtual envs)
         }
      })
    end
  }
}
```

**B. Treesitter Configuration (`lua/plugins/treesitter.lua`)**

* Manages parser installation and enables highlighting, indentation, etc..
* Requires a C compiler for building parsers.

```lua
-- lua/plugins/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- Use recommended version or latest commit 
    build = ':TSUpdate', -- Auto-run :TSUpdate on install/update 
    event = { "BufReadPre", "BufNewFile" }, -- Load early for highlighting 
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects', -- Optional: for enhanced text objects 
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { -- Specify required parsers 
          "python", "rst", "markdown", "markdown_inline", -- Core requirements
          "bash", "c", "diff", "gitcommit", "gitignore", "json", "yaml",
          "html", "css", "javascript", -- For Jinja context 
          "lua", "vim", "vimdoc", "query" -- Neovim dev 
        },
        auto_install = true, -- Auto install parsers on first use 
        highlight = {
          enable = true, -- Enable syntax highlighting 
          additional_vim_regex_highlighting = false, -- Use Treesitter only 
        },
        indent = { enable = true }, -- Use treesitter for indentation 
        -- Optional Modules
        textobjects = { -- Configure Treesitter text objects 
          select = {
            enable = true,
            lookahead = true,
            keymaps = { -- Example keymaps 
              ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer", ["if"] = "@function.inner",
              ["ac"] = "@class.outer", ["ic"] = "@class.inner",
            },
          },
          -- Add move keymaps if desired 
        },
      }

      -- Setup Treesitter based folding (replaces indent folding) 
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false -- Default folding off, toggle with 'zi'

      -- Configure RST injection for Python docstrings 
      -- Create ~/.config/nvim/after/queries/python/injections.scm with content:
      -- (module (expression_statement (string (string_content) @rst)) (#set! injection.language "rst") (#set! injection.include-children))
      -- (function_definition body: (block . (expression_statement (string (string_content) @rst))) (#set! injection.language "rst") (#set! injection.include-children))
      -- (class_definition body: (block . (expression_statement (string (string_content) @rst))) (#set! injection.language "rst") (#set! injection.include-children))
      -- Ensure rst parser is installed
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.python.filetype_to_parsername = { "python", "rst" } -- 

    end,
  },
  -- Dependency listed separately for clarity
   { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- 
}

```

**C. Completion (`nvim-cmp`) and Snippets (`LuaSnip`) (`lua/plugins/completion.lua`)**

* `nvim-cmp` framework integrates various completion sources.
* `LuaSnip` is the snippet engine.
* Sources include LSP (`cmp-nvim-lsp`), snippets (`cmp_luasnip`), buffer text (`cmp-buffer`), paths (`cmp-path`), and command line (`cmp-cmdline`).
* `friendly-snippets` provides standard snippet collections.

```lua
-- lua/plugins/completion.lua
return {
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter", -- Load on entering insert mode 
    dependencies = {
      -- Sources
      'hrsh7th/cmp-nvim-lsp', -- 
      'hrsh7th/cmp-buffer', -- 
      'hrsh7th/cmp-path', -- For file path completion 
      'hrsh7th/cmp-cmdline', -- 
      -- Snippet Engine & Source
      {
          "L3MON4D3/LuaSnip", -- Snippet engine 
          version = "v2.*", -- Use latest major release 
          build = "make install_jsregexp", -- Optional: for regex performance 
          dependencies = { "rafamadriz/friendly-snippets" }, -- 
      },
      'saadparwaiz1/cmp_luasnip', -- Snippet source for cmp 
      -- Optional: Icons
      -- 'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      -- Optional: lspkind setup if installed
      -- local lspkind = require('lspkind')

      -- Load friendly-snippets (can also be done in friendly-snippets spec)
      require("luasnip.loaders.from_vscode").lazy_load() -- 
      -- Load custom snippets from lua/custom-snippets/
      require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config").. "/lua/custom-snippets" }}) -- 


      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- Use LuaSnip for expansion 
          end,
        },
        window = { -- Optional: bordered windows
           -- completion = cmp.config.window.bordered(),
           -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll documentation back 
          ['<C-f>'] = cmp.mapping.scroll_docs(4), -- Scroll documentation forward 
          ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion 
          ['<C-e>'] = cmp.mapping.abort(), -- Close completion 
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection 
          -- Tab mapping: Cycle, Expand/Jump Snippet, Fallback 
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }), -- 
        }),
        sources = cmp.config.sources({ -- Configure sources 
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' }, -- Ensure path source is included 
        }),
        -- Optional: lspkind formatting
        -- formatting = { format = lspkind.cmp_format({...}) }, -- 
      })

      -- Command line completion setup 
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }) -- 
      })
      -- Search completion setup
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } } -- 
      })
    end,
  },
  -- Ensure dependencies are listed if not solely defined within nvim-cmp spec
   { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
   { "saadparwaiz1/cmp_luasnip" },
   { "rafamadriz/friendly-snippets" },
}
```

**D. Fuzzy Finding (`telescope.nvim`) (`lua/plugins/telescope.lua`)**

* Recommended fuzzy finder, integrates well with LSP/Treesitter.
* Uses `plenary.nvim` dependency.
* `telescope-fzf-native.nvim` extension improves performance.

```lua
-- lua/plugins/telescope.lua
return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope", -- Lazy-load on command 
    -- Or use `keys` to lazy-load on specific mappings
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required dependency 
      { -- Optional: Performance improvement using FZF sorter 
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make', -- Needs make or cmake 
        cond = function() return vim.fn.executable 'make' == 1 end, -- Check if make exists
      },
       -- Optional: Snippet searching extension
       -- { 'nvim-telescope/telescope-snippets.nvim' } -- 
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup {
        defaults = {
          path_display = { 'smart' }, -- Shorten paths 
          mappings = { -- Custom mappings inside Telescope window 
            i = {
              ["<C-j>"] = actions.move_selection_next, -- 
              ["<C-k>"] = actions.move_selection_previous, -- 
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- Send to quickfix list 
              ["<esc>"] = actions.close,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next, -- 
              ["<C-k>"] = actions.move_selection_previous, -- 
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- 
              ["q"] = actions.close,
            },
          },
          -- Use fzf native sorter if installed 
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            }
          },
        },
        pickers = { -- Configure specific pickers 
           buffers = { sort_mru = true, ignore_current_buffer = true }, -- 
           -- find_files, git_files, live_grep, etc. configurations
        },
      }

      -- Load extensions 
      pcall(telescope.load_extension, 'fzf')
      -- pcall(telescope.load_extension, 'snippets') -- If extension installed
    end,
  }
}
```

**E. Theme (`gruvbox.nvim`) (`lua/plugins/theme.lua`)**

* Set `priority = 1000` and `lazy = false` to load early.
* Remember to set `vim.o.background = "dark"` *before* loading the theme.

```lua
-- lua/plugins/theme.lua
return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Load early 
    lazy = false, -- Load on startup 
    config = function()
      -- Background is set in init.lua or core options file
      require("gruvbox").setup({
        terminal_colors = true, -- 
        undercurl = true, -- 
        underline = true, -- 
        bold = true, -- 
        italic = { -- Configure italics 
          strings = false, -- User preference
          comments = true, -- User preference
          operators = false,
          folds = true,
        },
        contrast = "medium", -- Or "soft", "hard" 
        -- palette_overrides = {}, -- Customize colors 
      })
      -- Colorscheme command is called after lazy setup in init.lua
      -- vim.cmd.colorscheme "gruvbox"
    end,
  }
}
```

**F. Statusline (`lualine.nvim`) (`lua/plugins/lualine.lua`)**

* Uses `nvim-web-devicons` for icons.
* Configure sections and components.
* Requires a Nerd Font for Powerline separators (, , , ).
* Integrates `gitsigns` for diff status.

```lua
-- lua/plugins/lualine.lua
return {
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy", -- Load late 
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Icons dependency 
    opts = function()
      -- Function to get git signs status 
       local function gitsigns_status()
         local gs = package.loaded.gitsigns
         if gs then
           local status = gs.get_hunks()
           if status then
             return { added = status.added, modified = status.changed, removed = status.removed } -- 
           end
         end
         return {}
       end

      return {
        options = {
          icons_enabled = true, -- 
          theme = 'auto', -- Or 'gruvbox' 
          -- Powerline glyphs require Nerd Font 
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = { statusline = {}, winbar = {} }, -- 
          globalstatus = false, -- 
        },
        sections = { -- Define components in sections 
          lualine_a = {'mode'}, -- 
          lualine_b = {'branch', -- 
                       {'diff', source = gitsigns_status, symbols = {added = '+', modified = '~', removed = '-'}}}, -- Use gitsigns 
          lualine_c = {{'filename', path = 1}}, -- Relative path 
          lualine_x = {'diagnostics', 'encoding', 'fileformat', 'filetype'}, -- Add diagnostics 
          lualine_y = {'progress'}, -- 
          lualine_z = {'location'} -- 
        },
        inactive_sections = { -- Sections for inactive windows 
           lualine_c = {{'filename', path = 1}},
           lualine_x = {'location'},
        },
        -- extensions = {'nvim-tree', 'toggleterm'} -- Optional integrations 
      }
    end,
  }
}
```

**G. Surrounding (`nvim-surround`) (`lua/plugins/surround.lua`)**

* Provides `ys`, `ds`, `cs` mappings like `vim-surround`.

```lua
-- lua/plugins/surround.lua
return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use latest stable release 
    event = "VeryLazy", -- Load when needed 
    config = function()
      require("nvim-surround").setup({
        -- No extra config needed for basic functionality 
      })
    end
  }
}
```

**H. Commenting (`Comment.nvim`) (`lua/plugins/comment.lua`)**

* Feature-rich commenting, similar to NERDCommenter.
* Use `JoosepAlviste/nvim-ts-context-commentstring` for better context awareness.

```lua
-- lua/plugins/comment.lua
return {
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy", -- Or load on keymap 
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' }, -- 
    opts = {
      padding = true, -- Add space after delimiter 
      sticky = true, -- Keep cursor position 
      -- Default mappings (can be remapped) 
      toggler = { line = 'gcc', block = 'gbc' },
      opleader = { line = 'gc', block = 'gb' },
      -- Enable Treesitter context hook 
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    },
  },
  -- Context commentstring dependency setup
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
     opts = { enable_autocmd = false }, -- Trigger via hook 
  }
}
```

**I. Git Integration (`gitsigns.nvim`) (`lua/plugins/gitsigns.lua`)**

* Shows Git changes in the sign column.
* Provides hunk navigation, staging, resetting, blaming, etc..

```lua
-- lua/plugins/gitsigns.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load when opening files 
    opts = {
      signs = { -- Customize signs (requires Nerd Font) 
        add = { text = '│' }, change = { text = '│' }, delete = { text = '_' },
        topdelete = { text = '‾' }, changedelete = { text = '~' }, untracked = { text = '┆' },
      },
      signcolumn = true, -- 
      numhl = false, -- 
      linehl = false, -- 
      current_line_blame = false, -- Toggle with command 
      -- Keymaps are setup via on_attach for buffer locality 
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true, desc = "GitSigns" }

        -- Navigation 
        map('n', ']h', function() gs.next_hunk({navigation_message = false}) end, opts)
        map('n', '[h', function() gs.prev_hunk({navigation_message = false}) end, opts)
        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', opts) -- Stage Hunk 
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', opts) -- Reset Hunk 
        map('n', '<leader>hS', gs.stage_buffer, opts) -- Stage Buffer 
        map('n', '<leader>hR', gs.reset_buffer, opts) -- Reset Buffer 
        map('n', '<leader>hu', gs.undo_stage_hunk, opts) -- Undo Stage Hunk 
        map('n', '<leader>hp', gs.preview_hunk, opts) -- Preview Hunk 
        map('n', '<leader>hb', gs.blame_line, opts) -- Blame Line 
        map('n', '<leader>hd', gs.diffthis, opts) -- Diff This ~ Index 
        -- Text object 
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', opts)
      end
    },
  }
}
```

### 4. Key Mappings (`lua/core/keymaps.lua`)

Create a dedicated file for your key mappings (e.g., `lua/core/keymaps.lua`) and require it in `init.lua`. Use `vim.keymap.set(mode, lhs, rhs, opts)`.

```lua
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
```

### 5. Custom Snippets (`lua/custom-snippets/`)

Create Lua files named after the filetype (e.g., `lua/custom-snippets/python.lua`).

**Example (`lua/custom-snippets/python.lua`):**

```lua
-- lua/custom-snippets/python.lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s({trig = "def", name = "Function"}, fmt([[
def {}({}):
    """{}"""
    {}
]], { i(1, "name"), i(2, "params"), i(3, "docstring"), i(0) })), -- 

  s({trig = "class", name = "Class"}, fmt([[
class {}({}):
    """{}"""
    def __init__(self{}):
        {}
        {}
]], { i(1, "ClassName"), i(2, "Base"), i(3, "docstring"), i(4, ", args"), i(5, "pass"), i(0) })), -- 

  s({trig = "ifmain", name = "if __name__ == '__main__"}, fmt([[
if __name__ == "__main__":
    {}
]], { i(0) })), -- 
}
```

This consolidated guide should provide a solid foundation for setting up your Neovim configuration based on the detailed recommendations in the provided document. Remember to install the necessary dependencies (like a C compiler for Treesitter, `fzf` for `telescope-fzf-native`, and Nerd Fonts for icons/separators) and consult the documentation for each plugin for more advanced customization.
