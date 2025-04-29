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
