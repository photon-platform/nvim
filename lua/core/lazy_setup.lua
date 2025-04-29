-- ~/.config/nvim/lua/core/lazy_setup.lua

-- Bootstrap lazy.nvim
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

-- Setup lazy.nvim
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
