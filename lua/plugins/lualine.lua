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
