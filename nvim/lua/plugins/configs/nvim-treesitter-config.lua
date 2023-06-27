require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "markdown", -- required by lspsaga
    "markdown_inline", -- required by lspsaga
  },
  highlight = {
    enable = true,
    disable = {
      "markdown", -- it sucks
      "latex", -- handled by vimtex
    },
  },
  sync_install = false,
  auto_install = true,
  context_commentstring = {
    enable = true,
  },
  yati = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  matchup = {
    enable = true,
  },
}
