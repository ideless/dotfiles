local format = require("format")

return {
  "folke/lazy.nvim",

  -- keymap hint
  "folke/which-key.nvim",

  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- guess indent
  {
    "nmac427/guess-indent.nvim",
    event = "InsertEnter",
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
    event = "VeryLazy",
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

  -- enhanced search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        ";;",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        ";s",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
    },
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = false,
    },
  },

  -- search and replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<Leader>sr", mode = { "n", "x" }, desc = "Replace in document" },
      { "<Leader>sR", mode = { "n", "x" }, desc = "Replace in workspace" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local wk = require("which-key")
      local sp = require("spectre")
      wk.register({
        r = { sp.open_file_search, "Replace in document" },
        R = { sp.open_visual, "Replace in workspace" },
      }, { prefix = "<Leader>s" })

      wk.register({
        r = { "<esc><cmd>lua require('utils').open_spectre(true)<CR>", "Replace in document" },
        R = { "<esc><cmd>lua require('utils').open_spectre(false)<CR>", "Replace in workspace" },
      }, { prefix = "<Leader>s", mode = "x" })
    end,
  },
}
