require("guess-indent").setup {}

vim.cmd([[autocmd InsertEnter * :GuessIndent]])
