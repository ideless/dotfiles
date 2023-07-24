local format = require("format")

return {
  "folke/lazy.nvim",

  -- keymap hint
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>t"] = { name = "+tasks" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+hunks" },
        ["<Leader>l"] = { name = "+lsp" },
        ["<Leader>s"] = { name = "+search" },
        ["<Leader>u"] = { name = "+utils" },
        ["<Leader>d"] = { name = "+diagnostics" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- guess indent
  {
    "nmac427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("guess-indent").setup {}

      require("which-key").register {
        ["<Leader>ui"] = { "<Cmd>GuessIndent<CR>", "Guess indent" },
      }
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
      { "<Leader>gg", desc = "Gitui" },
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
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local gitui = Terminal:new { cmd = "gitui", hidden = true }

      vim.keymap.set("n", "<Leader>gg", function()
        gitui:toggle()
      end, { noremap = true, silent = true, desc = "Gitui" })
    end,
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
    opts = {
      open_cmd = "new", -- open horizontal split (instead of default vertical)
    },
    config = function(_, opts)
      local wk = require("which-key")
      local sp = require("spectre")

      sp.setup(opts)

      wk.register({
        r = { sp.open_file_search, "Replace in document" },
        R = { sp.open_visual, "Replace in workspace" },
      }, { prefix = "<Leader>s" })

      function OpenSpectre(is_cur)
        local su = require("spectre.utils")
        local opts = {}

        if is_cur then
          opts.path = vim.fn.fnameescape(vim.fn.expand("%:p:."))

          if vim.loop.os_uname().sysname == "Windows_NT" then
            opts.path = vim.fn.substitute(opts.path, "\\", "/", "g")
          end
        end

        opts.search_text = su.get_visual_selection()
        opts.search_text = vim.fn.escape(opts.search_text, ".+*?^$()[]{}|\\")

        format.save_without_format()
        sp.open(opts)
      end

      wk.register({
        r = { "<esc><cmd>lua OpenSpectre(true)<CR>", "Replace in document" },
        R = { "<esc><cmd>lua OpenSpectre(false)<CR>", "Replace in workspace" },
      }, { prefix = "<Leader>s", mode = "x" })
    end,
  },
}
