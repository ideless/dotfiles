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
      require("plugins.configs.which-key-config")
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
      require("plugins.configs.guess-indent-config")
    end,
  }

  use {
    "terrortylor/nvim-comment",
    config = function()
      require("plugins.configs.comment-config")
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
      require("plugins.configs.neo-tree-config")
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
      require("plugins.configs.telescope-config")
    end,
  }

  use {
    "neovim/nvim-lspconfig", -- config lsp servers in mason-config.lua
    config = function()
      require("plugins.configs.lspconfig-config")
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = "plenary.nvim",
    config = function()
      require("plugins.configs.null-ls-config")
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
      require("plugins.configs.mason-config")
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
      require("plugins.configs.cmp-config")
    end,
  }

  use {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("plugins.configs.bufferline-config")
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("plugins.configs.lualine-config")
    end,
  }

  use {
    "github/copilot.vim",
    config = function()
      require("plugins.configs.copilot-config")
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
      { "yioneko/nvim-yati", after = "nvim-treesitter" },
    },
    config = function()
      require("plugins.configs.nvim-treesitter-config")
    end,
  }

  use {
    "phaazon/hop.nvim",
    config = function()
      require("plugins.configs.hop-config")
    end,
  }

  use {
    "lervag/vimtex",
    config = function()
      require("plugins.configs.vimtex-config")
    end,
  }

  use {
    "ojroques/nvim-osc52",
    config = function()
      require("plugins.configs.nvim-osc52-config")
    end,
  }

  use {
    "folke/tokyonight.nvim",
    config = function()
      require("plugins.configs.tokyonight-config")
    end,
  }

  use {
    "glepnir/lspsaga.nvim",
    opt = true,
    branch = "main",
    event = "LspAttach",
    config = function()
      require("plugins.configs.lspsaga-config")
    end,
    requires = {
      "nvim-tree/nvim-web-devicons",
      --Please make sure you install markdown and markdown_inline parser
      "nvim-treesitter/nvim-treesitter",
    },
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.configs.gitsigns-config")
    end,
  }

  use {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugins.configs.toggleterm-config")
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.configs.indent-blankline-config")
    end,
  }

  use {
    "nvim-pack/nvim-spectre",
    config = function()
      require("plugins.configs.spectre-config")
    end,
  }

  -- use("andymass/vim-matchup")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
