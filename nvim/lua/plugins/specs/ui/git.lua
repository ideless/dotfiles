return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function(_, opts)
      local gs = require("gitsigns")
      local wk = require("which-key")

      gs.setup(opts)

      wk.register {
        ["[h"] = { gs.prev_hunk, "Previous hunk" },
        ["]h"] = { gs.next_hunk, "Previous hunk" },
      }

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
        name = "Git",
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
