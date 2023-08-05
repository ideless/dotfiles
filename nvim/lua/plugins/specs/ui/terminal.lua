return {
  {
    "akinsho/toggleterm.nvim",
    keys = {
      -- <A-*> does not seem to work in which-key, put them here instead
      { "<A-t>", mode = { "n", "i", "x", "t" }, silent = true },
      { "<A-T>g", mode = { "n", "i", "x", "t" }, desc = "Gitui", silent = true },
      {
        "<A-T>=",
        "<Cmd>ToggleTerm direction=float<CR>",
        mode = { "n", "i", "x", "t" },
        desc = "Toggle term (float)",
        silent = true,
      },
      {
        "<A-T>\\",
        "<Cmd>ToggleTerm direction=vertical<CR>",
        mode = { "n", "i", "x", "t" },
        desc = "Toggle term (vertical)",
        silent = true,
      },
      {
        "<A-T>-",
        "<Cmd>ToggleTerm direction=horizontal<CR>",
        mode = { "n", "i", "x", "t" },
        desc = "Toggle term (horizontal)",
        silent = true,
      },
      { "<A-T>s", "<Cmd>TermSelect<CR>", mode = { "n", "i", "x", "t" }, desc = "Select term", silent = true },
      { "<A-T>n", ":ToggleTermSetName<CR>", mode = "n", desc = "Set term name", silent = true },
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
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local gitui = Terminal:new { cmd = "gitui", hidden = true }

      vim.keymap.set({ "n", "i", "x", "t" }, "<A-t>", function()
        if gitui:is_open() then
          gitui:close()
        else
          require("toggleterm").toggle()
        end
      end, { noremap = true, silent = true })

      vim.keymap.set({ "n", "i", "x", "t" }, "<A-T>g", function()
        gitui:toggle()
      end, { noremap = true, silent = true })

      vim.keymap.set("n", "<Leader>gg", function()
        gitui:open()
      end, { noremap = true, silent = true, desc = "Gitui" })
    end,
  },
}
