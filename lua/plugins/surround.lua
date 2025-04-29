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
