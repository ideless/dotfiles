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
    config = function()
      require("guess-indent").setup {}
      vim.cmd([[autocmd InsertEnter * :GuessIndent]])
    end,
  },

  -- toggle comment
  {
    "terrortylor/nvim-comment",
    keys = {
      { "<C-_>", "<Cmd>CommentToggle<CR>", mode = "i" },
      { "<C-/>", "<Cmd>CommentToggle<CR>", mode = "i" },
      { "<C-_>", ":CommentToggle<CR>", mode = { "n", "x" } },
      { "<C-/>", ":CommentToggle<CR>", mode = { "n", "x" } },
    },
    config = function()
      require("nvim_comment").setup {}
    end
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
    config = function()
      vim.keymap.set("x", "<Leader>y", require("osc52").copy_visual)
    end,
  },
  
  -- terminal
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<A-t>", "<Cmd>ToggleTerm direction=float<CR>", mode = { "i", "n", "t", "x" } },
      { "<A-T>\\", "<Cmd>ToggleTerm direction=vertical<CR>", mode = { "i", "n", "t", "x" } },
      { "<A-T>-", "<Cmd>ToggleTerm direction=horizontal<CR>", mode = { "i", "n", "t", "x" } },
      { "<C-\\>", "<Cmd>ToggleTermSendCurrentLine<CR>", mode = "n" },
      { "<C-\\>", ":ToggleTermSendVisualLines<CR>", mode = "x" },
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
    init = function()
      vim.opt.list = true
    end,
  },

  -- search and replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { "<Leader>sr", "<Cmd>Spectre<CR>", desc = "Replace in files" },
    }
  }
}
