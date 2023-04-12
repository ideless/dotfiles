require("bufferline").setup {
  options = {
    numbers = "none",
    indicator = {
      style = "underline",
    },
    buffer_close_icon = "",
    diagnostics = "nvim_lsp",
  },
}
