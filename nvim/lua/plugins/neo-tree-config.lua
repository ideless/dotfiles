require("neo-tree").setup {
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false, -- only works on Windows for hidden files/directories
      hide_by_name = {
        "node_modules",
        ".git",
        "__pycache__",
        "Pipfile.lock",
      },
    },
  },
}
