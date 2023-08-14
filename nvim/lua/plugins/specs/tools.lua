return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-e>",
          accept_word = "<C-Right>",
          next = "<C-Down>",
          prev = "<C-Up>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        tex = false,
      },
    },
  },

  {
    "lervag/vimtex",
    -- ft = "tex",
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = "curl -X POST http://localhost:5050/api/vimtex/view"
      vim.g.vimtex_view_general_options = "-F 'pdf=@pdf' -F 'tex=@tex' -F 'line=@line' -F 'col=@col'"

      -- vim.g.vimtex_view_method = "zathura"

      -- vim.g.vimtex_view_general_viewer = "okular.exe"
      -- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }

      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_syntax_enabled = 0
    end,
  },

  -- the builtin ltex code actions (add to dict) is broken
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" }, -- TODO: it gets load when opening diagnostic of other ls
    dependencies = { "neovim/nvim-lspconfig" },
    -- opts = {
    --   path = ".vscode",
    --   load_langs = { "en-US" },
    --   init_check = true,
    -- },
  },

  -- task runner
  {
    "stevearc/overseer.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
    },
    keys = {
      { "<Leader>to", "<Cmd>OverseerToggle<CR>", desc = "Toggle window" },
      { "<Leader>ts", "<Cmd>OverseerSaveBundle<CR>", desc = "Save bundle" },
      { "<Leader>tl", "<Cmd>OverseerLoadBundle<CR>", desc = "Load bundle" },
      { "<Leader>td", "<Cmd>OverseerDeleteBundle<CR>", desc = "Delete bundle" },
      { "<Leader>tt", "<Cmd>OverseerRun<CR>", desc = "Run a task from a template" },
      { "<Leader>tT", "<Cmd>OverseerRunCmd<CR>", desc = "Run a raw shell command" },
      { "<Leader>ti", "<Cmd>OverseerInfo<CR>", desc = "Display diagnostic information" },
      { "<Leader>tb", "<Cmd>OverseerBuild<CR>", desc = "Open the task builder" },
      { "<Leader>tq", "<Cmd>OverseerQuickAction<CR>", desc = "Run an action on the most recent/under cursor task" },
      { "<Leader>ta", "<Cmd>OverseerTaskAction<CR>", desc = "Select a task to run an action on" },
      { "<Leader>tc", "<Cmd>OverseerClearCache<CR>", desc = "Clear the task cache" },
    },
    opts = {},
  },

  -- signature help, docs and completion for the nvim lua API
  { "folke/neodev.nvim", opts = {} },
}
