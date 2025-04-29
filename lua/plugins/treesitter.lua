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
