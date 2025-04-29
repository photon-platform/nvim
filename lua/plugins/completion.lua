-- lua/plugins/completion.lua
return {
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter", -- Load on entering insert mode
    dependencies = {
      -- Sources
      'hrsh7th/cmp-nvim-lsp', --
      'hrsh7th/cmp-buffer', --
      'hrsh7th/cmp-path', -- For file path completion
      'hrsh7th/cmp-cmdline', --
      -- Snippet Engine & Source
      {
          "L3MON4D3/LuaSnip", -- Snippet engine
          version = "v2.*", -- Use latest major release
          build = "make install_jsregexp", -- Optional: for regex performance
          dependencies = { "rafamadriz/friendly-snippets" }, --
      },
      'saadparwaiz1/cmp_luasnip', -- Snippet source for cmp
      -- Optional: Icons
      -- 'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      -- Optional: lspkind setup if installed
      -- local lspkind = require('lspkind')

      -- Load friendly-snippets (can also be done in friendly-snippets spec)
      require("luasnip.loaders.from_vscode").lazy_load() --
      -- Load custom snippets from lua/custom-snippets/
      require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config").. "/lua/custom-snippets" }}) --


      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- Use LuaSnip for expansion
          end,
        },
        window = { -- Optional: bordered windows
           -- completion = cmp.config.window.bordered(),
           -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll documentation back
          ['<C-f>'] = cmp.mapping.scroll_docs(4), -- Scroll documentation forward
          ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion
          ['<C-e>'] = cmp.mapping.abort(), -- Close completion
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
          -- Tab mapping: Cycle, Expand/Jump Snippet, Fallback
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }), --
        }),
        sources = cmp.config.sources({ -- Configure sources
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' }, -- Ensure path source is included
        }),
        -- Optional: lspkind formatting
        -- formatting = { format = lspkind.cmp_format({...}) }, --
      })

      -- Command line completion setup
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }) --
      })
      -- Search completion setup
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } } --
      })
    end,
  },
  -- Ensure dependencies are listed if not solely defined within nvim-cmp spec
   { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
   { "saadparwaiz1/cmp_luasnip" },
   { "rafamadriz/friendly-snippets" },
}
