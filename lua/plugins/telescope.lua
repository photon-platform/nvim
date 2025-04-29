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
