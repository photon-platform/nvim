-- lua/plugins/comment.lua
return {
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy", -- Or load on keymap
    dependencies = {
      -- Mark as required to ensure it loads before Comment.nvim's config runs
      { 'JoosepAlviste/nvim-ts-context-commentstring', required = true },
    },
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
  -- The nvim-ts-context-commentstring dependency is now handled within the Comment.nvim spec
  -- Remove the separate entry here.
}
