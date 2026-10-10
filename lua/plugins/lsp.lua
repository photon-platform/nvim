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
      -- Keymaps and settings on LSP attach (Neovim 0.11+ standard)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
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

          -- Optional: Format on save
          if client and client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('LspFormatOnSave_' .. bufnr, { clear = true }),
              buffer = bufnr,
              callback = function() vim.lsp.buf.format({ async = true, bufnr = bufnr }) end,
            })
          end
        end,
      })

      -- Broadcast completion capabilities to all LSP servers (Neovim 0.11+)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Custom setup for lua_ls
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })

      -- Custom setup for ltex
      local java_executable = vim.fn.executable('java') == 1 and vim.fn.exepath('java') or nil
      if not java_executable then
        vim.notify(
          "LSP ltex: 'java' command not found in PATH. ltex-ls might not start." ..
          " Ensure Java is installed and in PATH, or set JAVA_HOME, or configure 'ltex.java.path' manually.",
          vim.log.levels.WARN
        )
      end
      vim.lsp.config('ltex', {
        settings = {
          ltex = {
            java = { path = java_executable },
          },
        },
      })

      -- Setup esbonio (managed externally via `uv tool install esbonio`)
      if vim.fn.executable('esbonio') == 1 then
        vim.lsp.config('esbonio', {
          cmd = { 'esbonio' },
        })
        vim.lsp.enable('esbonio')
      end

      -- Setup servers via mason-lspconfig (automatically installs & enables servers)
      require('mason-lspconfig').setup({
        ensure_installed = {
          'pyright',
          'bashls',
          'lua_ls',
          'marksman',
          'ltex',
          'html',
        },
      })
    end,
  },
}
