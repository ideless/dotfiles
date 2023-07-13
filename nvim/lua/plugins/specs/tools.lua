return {
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },
  {
    "lervag/vimtex",
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_general_viewer = "okular.exe"
      -- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }

      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_syntax_enabled = 0
    end,
  },
}