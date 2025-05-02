-- lua/plugins/lsp.lua
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- Mason installs servers
      'williamboman/mason-lspconfig.nvim', -- Integrates mason and lspconfig
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP status updates
      'hrsh7th/nvim-cmp', -- Required for cmp capabilities
      'hrsh7th/cmp-nvim-lsp', -- LSP completion source
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities() --

      -- Keymaps and settings on LSP attach
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') --
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true, desc = "LSP" }

        map('n', 'gd', vim.lsp.buf.definition, opts) --
        map('n', 'K', vim.lsp.buf.hover, opts) --
        map('n', 'gi', vim.lsp.buf.implementation, opts) --
        map('n', '<C-k>', vim.lsp.buf.signature_help, opts) --
        map('n', '<leader>rn', vim.lsp.buf.rename, opts) --
        map('n', '<leader>ca', vim.lsp.buf.code_action, opts) --
        map('n', 'gr', vim.lsp.buf.references, opts) --
        map('n', '<leader>ld', vim.diagnostic.open_float, opts) -- Show line diagnostics
        map('n', '[d', vim.diagnostic.goto_prev, opts) --
        map('n', ']d', vim.diagnostic.goto_next, opts) --

        -- Optional: Format on save
        if client.supports_method('textDocument/formatting') then --
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ async = true, bufnr = bufnr }) end, --
          })
        end
      end

      -- Setup servers via mason-lspconfig
      require('mason-lspconfig').setup({
        ensure_installed = { -- Add the LSPs you need
          'pyright', -- Recommended Python LSP
          'bashls',
          'lua_ls',
          'marksman', -- Markdown LSP
          'ltex', -- Optional: Markdown/RST Grammar/Style
          'esbonio', -- RST/Sphinx LSP
          'html', -- For Jinja2
         },
         handlers = {
           -- Default handler using capabilities and on_attach
           function(server_name)
             lspconfig[server_name].setup {
               capabilities = capabilities,
               on_attach = on_attach,
             }
           end,
           -- Custom setup for lua_ls (example)
           ["lua_ls"] = function()
             lspconfig.lua_ls.setup {
               capabilities = capabilities,
               on_attach = on_attach,
               settings = { -- Custom settings
                 Lua = {
                   runtime = { version = 'LuaJIT' },
                   diagnostics = { globals = { 'vim' } },
                   workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                   telemetry = { enable = false },
                 }
               }
             }
           end,
            -- Add custom setups for other servers if needed (e.g., pyright virtual envs)
            ["ltex"] = function()
              local lspconfig = require('lspconfig') -- Ensure lspconfig is required locally
              local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Get capabilities
              local on_attach = function(client, bufnr) -- Define or reuse on_attach
                 vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                 local map = vim.keymap.set
                 local opts = { buffer = bufnr, noremap = true, silent = true, desc = "LSP" }
                 map('n', 'gd', vim.lsp.buf.definition, opts)
                 map('n', 'K', vim.lsp.buf.hover, opts)
                 map('n', 'gi', vim.lsp.buf.implementation, opts)
                 map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                 map('n', '<leader>rn', vim.lsp.buf.rename, opts)
                 map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                 map('n', 'gr', vim.lsp.buf.references, opts)
                 map('n', '<leader>ld', vim.diagnostic.open_float, opts)
                 map('n', '[d', vim.diagnostic.goto_prev, opts)
                 map('n', ']d', vim.diagnostic.goto_next, opts)
                 if client.supports_method('textDocument/formatting') then
                   vim.api.nvim_create_autocmd('BufWritePre', {
                     group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
                     buffer = bufnr,
                     callback = function() vim.lsp.buf.format({ async = true, bufnr = bufnr }) end,
                   })
                 end
              end

              local java_executable = vim.fn.executable('java')
              local ltex_settings = {
                ltex = {
                  -- Explicitly set the java path if found, otherwise ltex will try its default discovery
                  java = { path = java_executable and java_executable or nil },
                  -- You might need to configure dictionary paths, etc. here too
                  -- dictionary = {},
                  -- disabledRules = {},
                }
              }
              if not java_executable or java_executable == '' then
                 vim.notify(
                    "LSP ltex: 'java' command not found in PATH. ltex-ls might not start." ..
                    " Ensure Java is installed and in PATH, or set JAVA_HOME, or configure 'ltex.java.path' manually.",
                    vim.log.levels.WARN
                 )
              end

              lspconfig.ltex.setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = ltex_settings,
              }
            end,
         }
      })
    end
  }
}
