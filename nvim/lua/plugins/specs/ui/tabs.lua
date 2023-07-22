return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
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
    config = function(_, opts)
      require("bufferline").setup(opts)

      require("which-key").register {
        ["gb"] = { ":BufferLinePick<CR>", "Pick buffer" },
        ["[b"] = { ":BufferLineCyclePrev<CR>", "Previous buffer" },
        ["]b"] = { ":BufferLineCycleNext<CR>", "Next buffer" },
      }
    end,
  },
}
