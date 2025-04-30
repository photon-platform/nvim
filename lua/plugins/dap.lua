
return {
  -- Core DAP plugin
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Installs the debugpy adapter
      {
        "mfussenegger/nvim-dap-python",
        ft = "python", -- Load only for python files
        config = function()
          -- Setup debugpy adapter using the user's Python environment
          -- Assumes python3 is available in PATH and points to the desired environment
          -- You might need to adjust this path if you use virtual environments or pyenv
          local python_path = vim.fn.executable("python3") or vim.fn.executable("python") or "python"
          -- Ensure dap-python is actually required and setup *before* defining the keymap
          local dap_python = require("dap-python")
          dap_python.setup(python_path)

          -- Define the Python-specific launch keymap HERE
          vim.keymap.set('n', '<leader>dp', function()
            require('dap').run({
              type = 'python',
              request = 'launch',
              name = "Launch file",
              program = "${file}", -- Debug the current file
              pythonPath = function()
                -- Now dap_python is guaranteed to be loaded
                return dap_python.get_executable_path()
              end,
            })
          end, { desc = "DAP: Debug Python File" })

          print("nvim-dap-python configured with path: " .. (python_path or "nil")) -- Add for debugging
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
              max_height = nil, -- Use default
              max_width = nil, -- Use default
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            controls = { enabled = true, element = "repl" },
            render = {
              max_type_length = nil, -- Show full type names
            }
          })

          local dap = require("dap")
          -- Automatically open/close UI on DAP events
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },
    },
    -- Define keymaps for DAP within the plugin spec for lazy loading
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
   },
   config = function()
      -- Basic DAP setup (can be empty if most config is in dependencies)
      -- You could add sign definitions here if you don't like the defaults
      -- vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
      -- vim.fn.sign_define('DapStopped', {text='▶️', texthl='', linehl='DiagnosticUnderline', numhl=''})
    end,
  },
}
