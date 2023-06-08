require("bufferline").setup {
  options = {
    numbers = "none",
    indicator = {
      style = "underline",
    },
    buffer_close_icon = "󰅖",
    diagnostics = "nvim_lsp",
  },
}

require("keymap").bufferline_set_keymap()
