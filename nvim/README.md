# Installation

- Install [neovim](https://neovim.io/).
- Clone neovim configuration files to the appropriate folder for your system. For Linux, this is typically `~/.config/nvim/`. For Windows, it is `~\AppData\Local\nvim\`.
- Open neovim, and it will install plugins automatically.
- Note that Language servers, formatters, and other tools need to be installed manually (See [Languages](#Languages)).

# Plugins

| Plugin                                                                | Description                 |
| --------------------------------------------------------------------- | --------------------------- |
| [packer.nvim](https://github.com/wbthomason/packer.nvim)              | Plugin manager              |
| [which-key.nvim](https://github.com/folke/which-key.nvim)             | Key bindings hint           |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)            | Autopair                    |
| [guess-indent.nvim](https://github.com/nmac427/guess-indent.nvim)     | Guess indent                |
| [nvim-comment](https://github.com/terrortylor/nvim-comment)           | Toggle comments             |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)       | File explorer               |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)    | Fuzzy finder                |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)            | Language server config      |
| [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)    | External LSP clients config |
| [mason.nvim](https://github.com/williamboman/mason.nvim)              | Package manager             |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                       | Code completion             |
| [bufferline.nvim](https://github.com/bufferline.nvim)                 | Tabs                        |
| [copilot.vim](https://github.com/github/copilot.vim)                  | Copilot                     |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Language parsers            |
| [hop.nvim](https://github.com/phaazon/hop.nvim)                       | Fast jump                   |
| [vimtex](https://github.com/lervag/vimtex)                            | LaTeX                       |
| [nvim-osc52](https://github.com/ojroques/nvim-osc52)                  | Copy via OSC52              |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)           | TokyoNight theme            |
| [lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim)               | LSP UI                      |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)           | Git signs                   |

# Dependencies

| Dependency                                          | For                               |
| --------------------------------------------------- | --------------------------------- |
| [ripgrep](https://github.com/BurntSushi/ripgrep)    | Telescope                         |
| gcc or any other C compiler                         | Treesitter parser compilation     |
| nodejs, python (with venv)                          | Installing some packages in Mason |
| [Nerd font](https://github.com/40huo/Patched-Fonts) | Icons and symbols                 |
| [zathura](https://pwmt.org/projects/zathura/)       | VimTeX PDF preview                |

# Keymaps

See `lua/keymap.lua`

# Colorscheme

Frist read this [slides](https://speakerdeck.com/cocopon/creating-your-lovely-color-scheme) about colorschemes.

See `lua/colors`

# Languages

First read [Neovim Spaghetti - LSP Servers, Linters, Formatters, and Treesitter](https://roobert.github.io/2022/12/03/Extending-Neovim/) to get a picture of luaguage configurations in neovim.

- Install language server & formatter & linter via `:Mason`
- (Optionally) add custom config in `lua/plugins/mason-config.lua`
- After opening a file, you can check attached
  - LSP server (language servers) by `:LspInfo`
  - null-ls server (formatters & linters) by `:NullLsInfo`
- Treesitter language parsers should be installed automatically

# Development tips

- Always run `:PackerCompile` after modifying packer configurations.
- View error/debug/info messages via `:messages`.
- Run `:checkhealth` to check plugins health (very helpful).
- Use `:hi`, `:TSEditQuery` and `<C-h>` (See `lua/keymap.lua`) to help configuring themes.
- Run `nvim --startuptime` to inspect startup time.
- Run `:luafile path/to/some.lua` to run lua scripts.

# Troubleshooting

- `treesitter/highlighter: Error executing lua: ...` wait or manually install missing Treesitter language parser by `:TSInstall`
- Tmux not rendering unicodes properly: run `tmux -u` instead of `tmux`
- Tmux not showing italic fonts: add `set -g default-terminal "xterm-256color"` to `~/.tmux.conf`
- Osc52 not working in tmux: add `set -s set-clipboard on` to `~/.tmux.conf`
