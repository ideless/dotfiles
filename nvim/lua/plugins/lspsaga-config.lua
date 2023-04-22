require("lspsaga").setup {
  symbol_in_winbar = {
    enable = false,
  },
  finder = {
    keys = {
      expand_or_jump = "<Enter>",
      quit = { "q", "<Esc>", "<C-c>" },
    },
  },
}

require("keymap").lspsaga_set_keymap()
