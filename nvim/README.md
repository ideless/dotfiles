# Plugins

| Plugin                                                             | Description       |
| ------------------------------------------------------------------ | ----------------- |
| [packer.nvim](https://github.com/wbthomason/packer.nvim)           | Plugin manager    |
| [which-key.nvim](https://github.com/folke/which-key.nvim)          | Key bindings hint |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)         | Autopair          |
| [guess-indent.nvim](https://github.com/nmac427/guess-indent.nvim)  | Guess indent      |
| [nvim-comment](https://github.com/terrortylor/nvim-comment)        | Toggle comments   |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)    | File explorer     |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder      |
| [mason.nvim](https://github.com/williamboman/mason.nvim)           | Package manager   |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)         | LSP config        |
| [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) | LSP bridge        |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                    | Code completion   |
| [bufferline.nvim](https://github.com/bufferline.nvim)              | Tabs              |
| [copilot.vim](https://github.com/github/copilot.vim)               | Copilot           |

# Dependencies

| Dependency                                          | For               |
| --------------------------------------------------- | ----------------- |
| [ripgrep](https://github.com/BurntSushi/ripgrep)    | Telescope         |
| [Nerd font](https://github.com/40huo/Patched-Fonts) | Icons and symbols |

# Keymaps

See `lua/keymap.lua`

# Theme

See `lua/theme.lua`

# Language config

Language server: see `lua/plugins/mason-config.lua`

Formatter: see `lua/plugins/null-ls-config.lua`

# Development tips

- Always run `:PackerCompile` after modifying packer configurations.
