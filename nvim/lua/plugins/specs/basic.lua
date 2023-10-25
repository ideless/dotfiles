local format = require("format")

return {
  {
    "folke/lazy.nvim",
    event = "VimEnter",
    keys = {
      { "<Leader>ul", ":Lazy<CR>", desc = "Open Lazy" },
    },
  },

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
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    -- commit = "667d2304e8eb9ddbfa7f962528cfce0a5edcc163", -- https://github.com/altermo/ultimate-autopair.nvim/issues/39
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
      -- { ";a", "<Cmd>HopAnywhere<CR>", desc = "Anywhere", mode = { "n", "o", "x" } },
      { "gc", "<Cmd>HopChar1<CR>", desc = "Goto character", mode = { "n", "o", "x" } },
      { "gl", "<Cmd>HopLineStart<CR>", desc = "Goto line", mode = { "n", "o", "x" } },
      { "gv", "<Cmd>HopVertical<CR>", desc = "Goto vertical", mode = { "n", "o", "x" } },
      -- { ";p", "<Cmd>HopPattern<CR>", desc = "Pattern", mode = { "n", "o", "x" } },
      { "gw", "<Cmd>HopWord<CR>", desc = "Goto word", mode = { "n", "o", "x" } },
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
          jump_labels = true,
        },
      },
    },
    keys = {
      {
        "gp",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Goto pattern",
      },
      {
        "vs",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Select treesitter",
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
      { "ca", desc = "Add surrounding", mode = { "n", "x" } },
      { "ds", desc = "Delete surrounding" },
      -- { ",f", desc = "Find right surrounding" },
      -- { ",F", desc = "Find left surrounding" },
      -- { ",h", desc = "highlight surrounding" },
      { "cs", desc = "Replace surrounding" },
      -- { ",n", desc = "Update n_lines" },
    },
    opts = {
      mappings = {
        add = "ca", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`
      },
    },
  },

  -- improved search
  {
    "backdround/improved-search.nvim",
    keys = {
      { "n", mode = { "n", "x", "o" }, desc = "Stable next" },
      { "N", mode = { "n", "x", "o" }, desc = "Stable previous" },
      { "*", mode = "x", desc = "Search forward" },
      { "#", mode = "x", desc = "Search backward" },
      { "|", mode = { "n", "x" }, desc = "Search in place" },
      -- { "|", mode = "n", desc = "Search by motion in place" },
    },
    config = function()
      local search = require("improved-search")

      -- Search next / previous.
      vim.keymap.set({ "n", "x", "o" }, "n", search.stable_next)
      vim.keymap.set({ "n", "x", "o" }, "N", search.stable_previous)

      -- Search current word without moving.
      vim.keymap.set("n", "|", search.current_word)

      -- Search selected text in visual mode
      vim.keymap.set("x", "|", search.in_place) -- search selection without moving
      vim.keymap.set("x", "*", search.forward) -- search selection forward
      vim.keymap.set("x", "#", search.backward) -- search selection backward

      -- Search by motion in place
      -- vim.keymap.set("n", "|", search.in_place)
    end,
  },
}
