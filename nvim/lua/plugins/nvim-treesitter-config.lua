require("nvim-treesitter.configs").setup {
    ensure_installed = {},
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
}
