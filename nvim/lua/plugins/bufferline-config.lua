require('bufferline').setup {
  options = {
    numbers = "ordinal",
    indicator = {
      style = 'underline',
    },
  },
  highlights = {
    buffer_selected = {
      bold = true,
      italic = true,
    },
  }
}
