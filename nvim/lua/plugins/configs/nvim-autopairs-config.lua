require("nvim-autopairs").setup {
  disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
  disable_in_macro = true, -- disable when recording or executing a macro
  disable_in_visualblock = true, -- disable when insert after visual block mode
  disable_in_replace_mode = true,
}
