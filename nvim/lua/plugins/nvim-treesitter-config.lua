require("nvim-treesitter.configs").setup {
    ensure_installed = {},
    highlight = {
        enable = true,
    },
    sync_install = false,
    auto_install = true,
    context_commentstring = {
        enable = true,
    },
}
