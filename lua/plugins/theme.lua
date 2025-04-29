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
