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
        [";"] = { name = "+jump" },
        [","] = { name = "+surround" },
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
    keys = {
      { ";a", "<Cmd>HopAnywhere<CR>", desc = "Anywhere", mode = { "n", "o", "x" } },
      { ";c", "<Cmd>HopChar1<CR>", desc = "Character", mode = { "n", "o", "x" } },
      { ";l", "<Cmd>HopLineStart<CR>", desc = "Line", mode = { "n", "o", "x" } },
      { ";v", "<Cmd>HopVertical<CR>", desc = "Vertical", mode = { "n", "o", "x" } },
      { ";p", "<Cmd>HopPattern<CR>", desc = "Pattern", mode = { "n", "o", "x" } },
      { ";w", "<Cmd>HopWord<CR>", desc = "Word", mode = { "n", "o", "x" } },
    },
    opts = {
      case_insensitive = false,
    },
  },

  -- enhanced search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          keys = { "f", "F", "t", "T" },
        },
      },
    },
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
      { "<A-t>", ":ToggleTerm direction=float<CR>", mode = { "n" }, silent = true },
      { "<A-t>", "<Cmd>ToggleTerm direction=float<CR>", mode = { "i", "x", "t" }, silent = true },
      { "<A-T>\\", ":ToggleTerm direction=vertical<CR>", mode = { "n" }, silent = true },
      { "<A-T>\\", "<Cmd>ToggleTerm direction=vertical<CR>", mode = { "i", "x", "t" }, silent = true },
      { "<A-T>-", ":ToggleTerm direction=horizontal<CR>", mode = { "n" }, silent = true },
      { "<A-T>-", "<Cmd>ToggleTerm direction=horizontal<CR>", mode = { "i", "x", "t" }, silent = true },
      { "<Leader>gg", desc = "Gitui", silent = true },
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
      winbar = {
        enabled = true,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end,
      },
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
        local o = {}

        if is_cur then
          o.path = vim.fn.fnameescape(vim.fn.expand("%:p:."))

          if vim.loop.os_uname().sysname == "Windows_NT" then
            o.path = vim.fn.substitute(o.path, "\\", "/", "g")
          end
        end

        o.search_text = su.get_visual_selection()
        o.search_text = vim.fn.escape(o.search_text, ".+*?^$()[]{}|\\")

        format.save_without_format()
        sp.open(o)
      end

      wk.register({
        r = { "<Esc><Cmd>lua OpenSpectre(true)<CR>", "Replace in document" },
        R = { "<Esc><Cmd>lua OpenSpectre(false)<CR>", "Replace in workspace" },
      }, { prefix = "<Leader>s", mode = "x" })
    end,
  },

  -- Add, delete, replace, find, highlight surrounding (like pair of parenthesis, quotes, etc.).
  {
    "echasnovski/mini.surround",
    keys = {
      { ",,", desc = "Add surrounding" },
      { ",d", desc = "Delete surrounding" },
      { ",f", desc = "Find right surrounding" },
      { ",F", desc = "Find left surrounding" },
      { ",h", desc = "highlight surrounding" },
      { ",r", desc = "Replace surrounding" },
      { ",n", desc = "Update n_lines" },
    },
    opts = {
      mappings = {
        add = ",,", -- Add surrounding in Normal and Visual modes
        delete = ",d", -- Delete surrounding
        find = ",f", -- Find surrounding (to the right)
        find_left = ",F", -- Find surrounding (to the left)
        highlight = ",h", -- Highlight surrounding
        replace = ",r", -- Replace surrounding
        update_n_lines = ",n", -- Update `n_lines`
      },
    },
  },
}
