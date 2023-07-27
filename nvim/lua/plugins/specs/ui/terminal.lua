return {
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
      { "<A-T>s", "<Cmd>TermSelect<CR>", mode = { "n", "i", "x", "t" }, silent = true },
      { "<A-T>n", ":ToggleTermSetName<CR>", mode = "n", silent = true },
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
}
