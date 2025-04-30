# Research Project: Diagnosing nvim-dap Python Debugging Issues with Pyenv

## 1. Problem Statement

Debugging Python code within Neovim using `nvim-dap`, `nvim-dap-python`, and `nvim-dap-ui` is failing intermittently or consistently when using a `pyenv` managed global Python version (3.13.2). Keybindings (`<leader>dp`, `<F5>`) result in errors like `attempt to call field 'get_executable_path' (a nil value)` or `Executable '1' not found`, suggesting issues with adapter configuration, plugin loading order, or environment detection.

## 2. Research Goal

To identify the root cause of the `nvim-dap-python` integration failures within a `pyenv` environment and establish a robust, reliable configuration for Python debugging in Neovim that follows best practices.

## 3. Current Configuration (`lua/plugins/dap.lua`)

```lua
-- lua/plugins/dap.lua @ commit ccda3bf (or later state if modified)
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

```

*(Note: Include any subsequent modifications or logging added after commit ccda3bf)*

## 4. Research Areas & Questions

### 4.1. Plugin Loading & Initialization (`lazy.nvim`, `nvim-dap`, `nvim-dap-python`)

*   What is the exact sequence of events when opening a Python file with `ft = "python"` on `nvim-dap-python`?
*   When does the `nvim-dap-python` `config` function run relative to the main `nvim-dap` `config` and `keys` setup?
*   Is there a race condition where `require('dap-python')` is called before its module is fully initialized and registered?
*   What guarantees does `lazy.nvim` provide about the availability of a module (`require`) within the `config` block of a dependent plugin vs. the main plugin?
*   Would changing the lazy-loading event (`VeryLazy`, `BufReadPost`, etc.) for `nvim-dap` or `nvim-dap-python` affect the outcome? What are the trade-offs?

### 4.2. `nvim-dap-python` Internals

*   What specific actions does `require("dap-python").setup(python_path)` perform?
    *   Does it register DAP adapters?
    *   Does it define DAP configurations?
    *   Does it perform checks on the `python_path` (e.g., check for `debugpy`)? What happens if these checks fail?
*   What logic does `require("dap-python").get_executable_path()` use?
    *   How does it discover the Python executable (e.g., current buffer, virtual envs, global path)?
    *   When is this function expected to be available? Only after `setup()` has successfully run?
    *   Does it cache the result?
*   Are there alternative ways to configure the Python adapter provided by `nvim-dap-python` without relying on `setup()` or `get_executable_path()` within the launch configuration?

### 4.3. `pyenv` Interaction

*   How does `vim.fn.executable("python3")` behave when `pyenv` shims are involved? Does it return the shim path or the resolved path?
*   How does `nvim-dap-python` (specifically `setup` and `get_executable_path`) handle being given a `pyenv` shim path vs. the actual executable path (e.g., `~/.pyenv/versions/3.13.2/bin/python`)?
*   Does the environment Neovim runs in (especially `PATH` and `PYENV_*` variables) correctly reflect the `pyenv global 3.13.2` setting? How to verify this reliably from within Neovim?
*   Are there known issues or specific configuration requirements for `nvim-dap-python` when using `pyenv` (global or local)? Check plugin documentation and issue trackers.
*   Could `pyenv`'s activation/shim mechanism interfere with how `nvim-dap` or `debugpy` launches the debug process?

### 4.4. `nvim-dap` Best Practices

*   What is the recommended way to define language-specific launch configurations?
    *   Within the language-specific DAP plugin's config (like the current approach)?
    *   Globally within the main `nvim-dap` config?
    *   Using `dap.configurations.python = { ... }`?
*   What is the difference between DAP *adapters* and *configurations*? How should `nvim-dap-python` be used in terms of registering adapters vs. defining launch configurations?
*   Is it better practice to explicitly define the `pythonPath` in the launch configuration (potentially resolving the `pyenv` path once during setup) rather than using a dynamic function like `get_executable_path`?
*   Review the purpose of `dap.continue()` vs. `dap.run_last()` vs. defining a specific launch configuration in a keymap. Is the current use of `<F5>` appropriate?

### 4.5. Debugging and Diagnostics

*   Utilize the enhanced logging added previously. Analyze the output carefully step-by-step.
*   Use `:DapShowLog` if available/relevant.
*   Can we manually configure and launch the adapter using `:DapSetLogLevel TRACE` and `:lua require('dap').run({...})` with hardcoded paths (both shim and real pyenv path) to isolate the issue?
*   Simplify the configuration temporarily (e.g., remove `nvim-dap-ui`) to rule out interactions.

## 5. Deliverables

*   A clear explanation of the root cause of the debugging failures.
*   A revised `lua/plugins/dap.lua` configuration that reliably works with the `pyenv global 3.13.2` setup.
*   Recommendations for best practices regarding DAP configuration, lazy loading, and `pyenv` usage within Neovim.
