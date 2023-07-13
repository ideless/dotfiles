return {
  "folke/lazy.nvim",

  -- keymap hint
  "folke/which-key.nvim",

  -- autopairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- guess indent
  {
    "nmac427/guess-indent.nvim",
    event = "VeryLazy",
    config = function()
      require("guess-indent").setup {}

      require("which-key").register {
        ["<Leader>i"] = { "<Cmd>GuessIndent<CR>", "Guess indent" },
      }
    end,
  },

  -- toggle comment
  {
    "terrortylor/nvim-comment",
    keys = {
      { "<C-_>", mode = { "i", "n", "x" } },
      { "<C-/>", mode = { "i", "n", "x" } },
    },
    config = function()
      require("nvim_comment").setup {}

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

  -- quick jump
  {
    "phaazon/hop.nvim",
    opts = {
      case_insensitive = false,
    },
    config = function(_, opts)
      require("hop").setup(opts)

      local wk = require("which-key")

      wk.register({
        name = "Hop",
        a = { "<Cmd>HopAnywhere<CR>", "Anywhere" },
        c = { "<Cmd>HopChar1<CR>", "Character" },
        l = { "<Cmd>HopLineStart<CR>", "Line" },
        v = { "<Cmd>HopVertical<CR>", "Vertical" },
        p = { "<Cmd>HopPattern<CR>", "Pattern" },
        w = { "<Cmd>HopWord<CR>", "Word" },
      }, { prefix = ";", mode = { "n", "o", "x" }, noremap = false }) -- mode cannot be set to "", otherwise <a> gets hijacked by matchit, seems to be a bug of which-key
    end,
  },

  -- osc52 copy
  {
    "ojroques/nvim-osc52",
    keys = {
      { "<Leader>y", mode = "x" },
    },
    config = function()
      require("which-key").register({
        ["<Leader>y"] = { require("osc52").copy_visual, "Copy to clipboard" },
      }, { mode = "x" })
    end,
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    keys = {
      -- <A-*> does not seem to work in which-key, put them here instead
      { "<A-t>", "<Cmd>ToggleTerm direction=float<CR>", mode = { "i", "n", "t", "x" }, silent = true },
      { "<A-T>\\", "<Cmd>ToggleTerm direction=vertical<CR>", mode = { "i", "n", "t", "x" }, silent = true },
      { "<A-T>-", "<Cmd>ToggleTerm direction=horizontal<CR>", mode = { "i", "n", "t", "x" }, silent = true },
      { "<C-\\>", "<Cmd>ToggleTermSendCurrentLine<CR>", mode = "n", silent = true },
      { "<C-\\>", ":ToggleTermSendVisualLines<CR>", mode = "x", silent = true },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      direction = "float",
      persist_mode = false,
    },
  },

  -- visualize whitespaces
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      space_char_blankline = " ",
    },
    config = function()
      vim.opt.list = true
    end,
  },

  -- search and replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = "<Leader>sr",
    config = function()
      require("which-key").register {
        ["<Leader>sr"] = { "<Cmd>Spectre<CR>", "Replace in multiple files" },
      }
    end,
  },
}
