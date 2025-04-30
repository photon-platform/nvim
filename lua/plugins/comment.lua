-- lua/plugins/comment.lua
return {
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy", -- Or load on keymap
    dependencies = {
      -- Mark as required to ensure it loads before Comment.nvim's config runs
      { 'JoosepAlviste/nvim-ts-context-commentstring' }, -- No longer need 'required = true' here as config ensures loading order
    },
    config = function()
      -- The pre_hook needs to be called *inside* the config function
      -- where the dependency is guaranteed to be loaded.
      require('Comment').setup {
        padding = true, -- Add space after delimiter
        sticky = true, -- Keep cursor position
        -- Default mappings (can be remapped)
        toggler = { line = 'gcc', block = 'gbc' },
        opleader = { line = 'gc', block = 'gb' },
        -- Enable Treesitter context hook
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  -- The nvim-ts-context-commentstring dependency is now handled within the Comment.nvim spec
  -- Remove the separate entry here. -- This comment is now slightly inaccurate but harmless
  -- Remove the separate entry here.
}
