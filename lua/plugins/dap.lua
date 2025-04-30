-- lua/plugins/dap.lua (Revised Configuration)
return {
  -- Core DAP plugin
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy", -- Load DAP fairly early, but not immediately
    dependencies = {
      -- Python DAP extension
      {
        "mfussenegger/nvim-dap-python",
        ft = "python", -- Load only for python files
        config = function()
          -- Explicitly find the pyenv python path
          local python_path = nil
          local handle = io.popen("pyenv which python")
          if handle then
            local result = handle:read("*a")
            handle:close()
            python_path = vim.fn.trim(result)
            -- Basic check if the path seems valid (not empty and not containing error messages)
            if python_path == "" or python_path:find("pyenv: python: command not found") or not vim.fn.executable(python_path) then
               print("nvim-dap-python: 'pyenv which python' failed or returned invalid path. Falling back.")
               python_path = nil
            end
          end

          -- Fallback if pyenv command failed or pyenv not in use
          if not python_path then
             python_path = vim.fn.executable("python3") or vim.fn.executable("python")
          end

          -- Final fallback
          if not python_path or python_path == "" then
             print("nvim-dap-python: Could not resolve Python path. Using default 'python'.")
             python_path = "python"
          end

          print("nvim-dap-python: Attempting setup with path: ".. python_path)
          -- Setup debugpy adapter using the resolved path
          local dap_python_status, dap_python = pcall(require, "dap-python")
          if dap_python_status then
            local setup_status, setup_result = pcall(dap_python.setup, python_path)
            if not setup_status then
               print("nvim-dap-python: Error calling dap_python.setup(): ".. tostring(setup_result))
            else
               print("nvim-dap-python: Setup called successfully with path: ".. python_path)
               -- Optionally configure test runner here if needed
               -- dap_python.test_runner = 'pytest'
            end
          else
             print("nvim-dap-python: Failed to require 'dap-python'.")
          end
        end,
      },

      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" }, -- Required dependency
        config = function()
          local dapui = require("dapui")
          dapui.setup({
            -- Layout configuration (customize as needed)
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 10,
                position = "bottom",
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            controls = { enabled = true, element = "repl" },
            render = {
              max_type_length = nil,
            }
          })
          print("nvim-dap-ui configured.")
        end,
      },
    },
    -- Define ALL DAP keymaps here to ensure they are loaded with nvim-dap core
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle Breakpoint" },
      { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: Set Conditional Breakpoint" },
      { "<leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP: Set Logpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP: Open REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP: Run Last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },
      { "<leader>do", function() require("dapui").open() end, desc = "DAP: Open UI" },
      { "<leader>dc", function() require("dapui").close() end, desc = "DAP: Close UI" },
      -- Revised Python launch keymap
      {
        "<leader>dp",
        function()
          -- Check if the current buffer is a Python file
          if vim.bo.filetype == 'python' then
            local dap = require('dap')
            -- Check if python configurations have been registered by dap-python.setup()
            if dap.configurations.python and #dap.configurations.python > 0 then
               -- Use dap.continue() which will pick the first appropriate 'launch' config
               -- or use dap.run() specifying the 'name' if needed.
               -- The default config name registered by dap-python.setup is typically sufficient.
               print("nvim-dap: Launching Python debug session...")
               dap.continue() -- dap.continue() implicitly uses registered configurations.
               -- Alternatively, explicitly run the default config registered by setup:
               -- dap.run({ type = 'python', request = 'launch', name = 'Launch file', program = '${file}' })
            else
              print("nvim-dap: No Python debug configurations found. 'nvim-dap-python' setup might have failed or not run yet.")
              vim.notify("nvim-dap: No Python debug configurations found.", vim.log.levels.WARN)
            end
          else
            print("nvim-dap: Not a Python file.")
            vim.notify("nvim-dap: Not a Python file.", vim.log.levels.INFO)
          end
        end,
        desc = "DAP: Debug Python File",
        -- No ft='python' here; let the function check filetype at runtime
      },
    },
    config = function()
      local dap_status, dap = pcall(require, "dap")
      local dapui_status, dapui = pcall(require, "dapui")

      if not dap_status then
          print("nvim-dap: Failed to require 'dap' in core config.")
          return
      end

      -- Basic DAP setup (signs, etc.) - Optional
      -- vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
      -- vim.fn.sign_define('DapStopped', {text='▶️', texthl='', linehl='DiagnosticUnderline', numhl=''})

      -- Setup DAP UI listeners only if dapui is available
      if dapui_status then
          print("nvim-dap: Setting up DAP UI listeners.")
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      else
          print("nvim-dap: 'dapui' not available, skipping UI listener setup.")
      end

      print("nvim-dap core configured.")
    end,
  },
}
