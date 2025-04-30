# Neovim Keymaps

This document lists the custom keymaps configured in `lua/core/keymaps.lua`.

**Note:** The leader key is set to `<Space>` in `lua/core/options.lua`.

## General Mappings

*   `n` `<leader>ev`: Edit init.lua
*   `n` `<leader>sv`: Source init.lua (Restart often better)
*   `n` `<leader>h`: No Highlight
*   `n` `<leader>w`: Trim Whitespace

## Buffer Navigation

*   `n` `<leader>n`: Next Buffer
*   `n` `<leader>p`: Previous Buffer
*   `n` `<leader>bd`: Delete Buffer

## Primeagen Remaps (Examples)

*   `n` `Y`: Yank to end of line
*   `n, x` `}`: Keep default behavior (or customize)
*   `n, x` `{`: Keep default behavior (or customize)
*   `n` `n`: Center on next search result (Commented out)
*   `n` `N`: Center on previous search result (Commented out)

## Telescope Mappings (Requires Telescope)

*   `n` `<leader>ff`: [F]ind [F]iles
*   `n` `<leader>fg`: [F]ind by [G]rep
*   `n` `<leader>fb`: [F]ind [B]uffers
*   `n` `<leader>fh`: [F]ind [H]elp
*   `n` `<leader>fo`: [F]ind [O]ld Files
*   `n` `<leader>ft`: [F]ind Project Sym[t]ols (LSP)
*   `n` `<leader>fT`: [F]ind Buffer Sym[T]ols (LSP)
*   `n` `<leader>fc`: [F]ind [C]ommands
*   `n` `<leader>fm`: [F]ind [M]arks
*   `n` `<leader>fS`: [F]ind [S]nippets (Commented out)

## Commenting Mapping (Requires Comment.nvim)

*   `n` `<leader>/`: Toggle Comment Line
*   `v` `<leader>/`: Toggle Comment Block

## GitSigns Mappings (Defined in lua/plugins/gitsigns.lua)

*   `n` `]h`: Go to next hunk
*   `n` `[h`: Go to previous hunk
*   `n, v` `<leader>hs`: Stage Hunk
*   `n, v` `<leader>hr`: Reset Hunk
*   `n` `<leader>hS`: Stage Buffer
*   `n` `<leader>hR`: Reset Buffer
*   `n` `<leader>hu`: Undo Stage Hunk
*   `n` `<leader>hp`: Preview Hunk
*   `n` `<leader>hb`: Blame Line
*   `n` `<leader>hd`: Diff This ~ Index
*   `o, x` `ih`: Select Hunk text object

## LSP Mappings (Defined in lua/plugins/lsp.lua)

*   `n` `gd`: Go to definition
*   `n` `K`: Show hover documentation
*   `n` `gi`: Go to implementation
*   `n` `<C-k>`: Show signature help
*   `n` `<leader>rn`: Rename symbol
*   `n` `<leader>ca`: Show code actions
*   `n` `gr`: Go to references
*   `n` `<leader>ld`: Show line diagnostics
*   `n` `[d`: Go to previous diagnostic
*   `n` `]d`: Go to next diagnostic

## Completion Mappings (Defined in lua/plugins/completion.lua)

*   `i` `<C-b>`: Scroll documentation back
*   `i` `<C-f>`: Scroll documentation forward
*   `i` `<C-Space>`: Trigger completion
*   `i` `<C-e>`: Close completion
*   `i` `<CR>`: Confirm selection
*   `i, s` `<Tab>`: Select next item, expand/jump snippet, or fallback
*   `i, s` `<S-Tab>`: Select previous item or jump back snippet

## Treesitter Text Objects (Defined in lua/plugins/treesitter.lua)

*   `a` `aa`: Around parameter
*   `i` `ia`: Inside parameter
*   `a` `af`: Around function
*   `i` `if`: Inside function
*   `a` `ac`: Around class
*   `i` `ic`: Inside class

## Debugging (DAP) Mappings (Defined in lua/plugins/dap.lua)

*   `n` `<F5>`: Continue
*   `n` `<F10>`: Step Over
*   `n` `<leader>di`: Step Into
*   `n` `<F12>`: Step Out
*   `n` `<leader>b`: Toggle Breakpoint
*   `n` `<leader>B`: Set Conditional Breakpoint
*   `n` `<leader>lp`: Set Logpoint
*   `n` `<leader>dr`: Open REPL
*   `n` `<leader>dl`: Run Last Debug Session
*   `n` `<leader>du`: Toggle DAP UI
*   `n` `<leader>do`: Open DAP UI
*   `n` `<leader>dc`: Close DAP UI
*   `n` `<leader>dp`: Debug Python File
