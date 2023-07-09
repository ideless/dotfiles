require("lspsaga").setup(vim.tbl_deep_extend("force", {
  symbol_in_winbar = {
    enable = false,
  },
  lightbulb = {
    enabled = false,
    enable_in_insert = false,
    sign = false,
    sign_priority = 0,
    virtual_text = false,
  },
}, require("keymap").lspsaga_keys()))

require("keymap").lspsaga_set_keymap()
