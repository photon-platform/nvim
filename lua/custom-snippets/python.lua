-- lua/custom-snippets/python.lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s({trig = "def", name = "Function"}, fmt([[
def {}({}):
    """{}"""
    {}
]], { i(1, "name"), i(2, "params"), i(3, "docstring"), i(0) })), --

  s({trig = "class", name = "Class"}, fmt([[
class {}({}):
    """{}"""
    def __init__(self{}):
        {}
        {}
]], { i(1, "ClassName"), i(2, "Base"), i(3, "docstring"), i(4, ", args"), i(5, "pass"), i(0) })), --

  s({trig = "ifmain", name = "if __name__ == '__main__"}, fmt([[
if __name__ == "__main__":
    {}
]], { i(0) })), --
}
