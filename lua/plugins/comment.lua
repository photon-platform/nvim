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
