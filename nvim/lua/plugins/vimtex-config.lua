vim.g.vimtex_quickfix_mode = 0

vim.g.vimtex_view_method = "zathura"
-- vim.g.vimtex_view_general_viewer = "okular.exe"
-- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
