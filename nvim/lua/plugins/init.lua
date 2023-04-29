local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  use {
    "folke/which-key.nvim",
    config = function()
      require("plugins.which-key-config")
    end,
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  }

  use {
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup {}
    end,
  }

  use {
    "terrortylor/nvim-comment",
    config = function()
      require("plugins.comment-config")
    end,
  }

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("plugins.neo-tree-config")
    end,
  }

  use {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    after = "which-key.nvim", -- needs to set keymaps via which-key
    config = function()
      require("plugins.telescope-config")
    end,
  }

  use {
    "neovim/nvim-lspconfig", -- config lsp servers in mason-config.lua
    config = function()
      require("plugins.lspconfig-config")
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = "plenary.nvim",
    config = function()
      require("plugins.null-ls-config")
    end,
  }

  use {
    "williamboman/mason.nvim",
    requires = {
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    after = {
      "which-key.nvim", -- needs to set keymaps via which-key
      "nvim-lspconfig",
      "null-ls.nvim",
    },
    config = function()
      require("plugins.mason-config")
    end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      require("plugins.cmp-config")
    end,
  }

  use {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("plugins.bufferline-config")
    end,
  }

  use {
    "github/copilot.vim",
    config = function()
      require("plugins.copilot-config")
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("plugins.nvim-treesitter-config")
    end,
  }

  use {
    "phaazon/hop.nvim",
    config = function()
      require("plugins.hop-config")
    end,
  }

  use {
    "lervag/vimtex",
    config = function()
      require("plugins.vimtex-config")
    end,
  }

  use {
    "ojroques/nvim-osc52",
    config = function()
      require("plugins.nvim-osc52-config")
    end,
  }

  use {
    "folke/tokyonight.nvim",
    config = function()
      require("plugins.tokyonight-config")
    end,
  }

  use {
    "glepnir/lspsaga.nvim",
    opt = true,
    branch = "main",
    event = "LspAttach",
    config = function()
      require("plugins.lspsaga-config")
    end,
    requires = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.gitsigns-config")
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
      require("plugins.lualine-config")
    end,
  }

  use {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugins.toggleterm-config")
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
