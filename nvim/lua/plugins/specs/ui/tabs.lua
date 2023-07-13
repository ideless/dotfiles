return {
  {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
      { "gb", ":BufferLinePick<CR>" },
      { "[b", ":BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "]b", ":BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
    opts = {
      options = {
        numbers = "none",
        indicator = {
          style = "underline",
        },
        buffer_close_icon = "󰅖",
        diagnostics = "nvim_lsp",
      },
    },
  },
}
