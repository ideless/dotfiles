return {
  -- syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "yioneko/nvim-yati",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    keys = {
      { "<Enter>", desc = "Increment selection" },
      { "<BS>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      ensure_installed = {
        "markdown", -- required by lspsaga
        "markdown_inline", -- required by lspsaga
      },
      highlight = {
        enable = true,
        disable = {
          "markdown", -- it sucks
          "latex", -- handled by vimtex
        },
      },
      sync_install = false,
      auto_install = true,
      context_commentstring = {
        enable = true,
      },
      yati = {
        enable = true,
      },
      indent = {
        enable = false,
      },
      matchup = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
