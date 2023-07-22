-- show recording in statusline (when cmdheight=0)
-- https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

local show_macro_recording = function()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "@" .. recording_register
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
      },
      sections = {
        lualine_c = {
          {
            "macro-recording",
            fmt = show_macro_recording,
          },
        },
      },
    },
    config = function(_, opts)
      local lualine = require("lualine")

      lualine.setup(opts)

      vim.api.nvim_create_autocmd("RecordingEnter", {
        callback = function()
          lualine.refresh {
            place = { "statusline" },
          }
        end,
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        callback = function()
          vim.defer_fn(function()
            lualine.refresh {
              place = { "statusline" },
            }
          end, 50)
          -- local timer = vim.loop.new_timer()
          -- timer:start(
          --   50,
          --   0,
          --   vim.schedule_wrap(function()
          --     print("refresh")
          --     lualine.refresh {
          --       place = { "statusline" },
          --     }
          --   end)
          -- )
        end,
      })
    end,
  },
}
