# A script to practice using the nvim-dap debugger.
#
# Remember your keymaps (from lua/plugins/dap.lua):
#   <F5>      : Continue execution until next breakpoint or end.
#   <F10>     : Step Over (execute current line, move to next).
#   <F11>     : Step Into (enter function calls on current line).
#   <F12>     : Step Out (finish current function, return to caller).
#   <leader>b : Toggle a breakpoint on the current line.
#   <leader>B : Set a conditional breakpoint (e.g., `i == 5`).
#   <leader>lp: Set a logpoint (prints message without stopping, e.g., `Value of x: {x}`).
#   <leader>dr: Open the DAP REPL to inspect/modify variables.
#   <leader>dl: Run the last debug session again.
#   <leader>du: Toggle the DAP UI visibility.
#   <leader>do: Open the DAP UI.
#   <leader>dc: Close the DAP UI.
#   <leader>dp: Launch the debugger for the current Python file.
#
# Practice Steps:
# 1. Open this file in Neovim.
# 2. Use `<leader>dp` to start the debugger. The DAP UI should open.
# 3. Use `<leader>b` to set breakpoints on various lines (e.g., inside loops, function calls).
# 4. Use `<F5>` to run until the first breakpoint.
# 5. Use `<F10>`, `<F11>`, `<F12>` to navigate the code execution.
# 6. Inspect variables in the DAP UI (Scopes, Watches).
# 7. Try setting a conditional breakpoint (`<leader>B`) in the loop (e.g., `i > 3`).
# 8. Try setting a logpoint (`<leader>lp`) to see variable values without stopping.
# 9. Use the REPL (`<leader>dr`) to evaluate expressions or change variable values mid-execution.

import time

def greet(name):
    """A simple function to greet someone."""
    # Practice: Step Into (<F11>) this function from the main block.
    message = f"Hello, {name}!"
    print(message)
    # Practice: Set a breakpoint here (<leader>b).
    # Practice: Step Out (<F12>) from here.
    return message

def complex_calculation(x, y):
    """A function with multiple steps."""
    # Practice: Step Over (<F10>) these lines.
    print(f"Starting calculation with x={x}, y={y}")
    a = x * 2
    b = y + 5
    # Practice: Inspect 'a' and 'b' in the DAP UI or REPL (<leader>dr).
    result = a / b if b != 0 else 0
    print(f"Calculation result: {result}")
    # Practice: Set a breakpoint here (<leader>b).
    return result

def loop_example(count):
    """A function with a loop."""
    print(f"Starting loop for {count} iterations.")
    total = 0
    for i in range(count):
        # Practice: Set a breakpoint here (<leader>b). Run (<F5>) multiple times.
        # Practice: Set a conditional breakpoint (`<leader>B`) here, e.g., `i == 3`.
        # Practice: Set a logpoint (`<leader>lp`) here, e.g., `Current total: {total}, i={i}`.
        print(f"  Iteration {i}")
        total += i
        time.sleep(0.1) # Simulate work
        # Practice: Use the REPL (<leader>dr) to check the value of 'total' or 'i'.
        # You could even try changing 'total' (e.g., `total = 100`).
    print(f"Loop finished. Final total: {total}")
    return total

def main():
    """Main execution function."""
    print("--- DAP Practice Script Start ---")

    # Practice: Set a breakpoint here (<leader>b) to start debugging.
    # Use <F10> to step over the next line.
    user_name = "Debugger User"

    # Practice: Use <F11> to step into the greet function.
    greeting = greet(user_name)
    print(f"Function returned: {greeting}")

    # Practice: Step over these lines (<F10>).
    num1 = 10
    num2 = 5
    calc_result = complex_calculation(num1, num2)
    print(f"Calculation returned: {calc_result}")

    # Practice: Step into the loop function (<F11>).
    # Inside the loop, practice breakpoints, conditional breakpoints, and logpoints.
    loop_total = loop_example(5)
    print(f"Loop function returned: {loop_total}")

    # Example of calling with values that might cause issues (division by zero handled)
    # Practice: Step through this call.
    complex_calculation(10, -5)

    print("--- DAP Practice Script End ---")
    # Practice: Set a final breakpoint here (<leader>b) or let execution finish (<F5>).

if __name__ == "__main__":
    main()
