require("neo-tree").setup {
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "document_symbols",
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        "node_modules",
        ".git",
        "__pycache__",
        "Pipfile.lock",
        "yarn.lock",
        "package-lock.json",
      },
    },
  },
  window = {
    mappings = {
      ["<C-c>"] = "close_window",
      ["<Space>"] = {
        "toggle_node",
        nowait = true,
      },
    },
  },
  source_selector = {
    winbar = true,
    statusline = false,
    sources = {
      { source = "filesystem" },
      { source = "buffers" },
      { source = "git_status" },
      { source = "document_symbols" },
    },
  },
}

require("keymap").neo_tree_set_keymap()
