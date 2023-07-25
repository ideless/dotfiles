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
      { "vs", desc = "Start increment selection" },
      { "<CR>", desc = "Increment selection", mode = "x" },
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
        enable_autocmd = false,
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
          init_selection = "vs",
          node_incremental = "<CR>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- comment
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "terrortylor/nvim-comment",
    keys = {
      { "<C-_>", mode = { "i", "n", "x" } },
      { "<C-/>", mode = { "i", "n", "x" } },
    },
    opts = {
      create_mappings = false,
      hook = function()
        require("ts_context_commentstring.internal").update_commentstring()
      end,
    },
    config = function(_, opts)
      require("nvim_comment").setup(opts)

      local wk = require("which-key")

      wk.register({
        ["<C-_>"] = { "<Cmd>CommentToggle<CR>", "Toggle comment" },
        ["<C-/>"] = { "<Cmd>CommentToggle<CR>", "Toggle comment" },
      }, { mode = { "i", "n" } })
      wk.register({
        ["<C-_>"] = { ":CommentToggle<CR>", "Toggle comment" },
        ["<C-/>"] = { ":CommentToggle<CR>", "Toggle comment" },
      }, { mode = { "x" } })
    end,
  },
}
