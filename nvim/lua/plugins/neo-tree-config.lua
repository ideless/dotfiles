require("neo-tree").setup {
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
}
