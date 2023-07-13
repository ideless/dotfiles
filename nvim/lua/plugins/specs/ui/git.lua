return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    config = function(_, opts)
      local gs = require("gitsigns")
      local wk = require("which-key")

      gs.setup(opts)

      vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Previous hunk" })
      vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })

      wk.register({
        name = "Hunk",
        s = { gs.stage_hunk, "Stage hunk" },
        u = { gs.undo_stage_hunk, "Undo stage hunk" },
        r = { gs.reset_hunk, "Reset hunk" },
        S = { gs.stage_buffer, "Stage buffer" },
        R = { gs.reset_buffer, "Reset buffer" },
        p = { gs.preview_hunk, "Preview hunk" },
        b = { gs.blame_line, "Blame line" },
        t = { gs.toggle_current_line_blame, "Toggle blame line" },
      }, { prefix = "<Leader>h" })

      wk.register({
        d = { gs.diffthis, "Diff" },
        D = {
          function()
            gs.diffthis("~")
          end,
          "Diff against last commit",
        },
      }, { prefix = "<Leader>g" })
    end,
  },
}
