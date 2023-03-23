local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- auto recompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'windwp/nvim-autopairs'
  require("nvim-autopairs").setup {}

  use 'nmac427/guess-indent.nvim'
  require("guess-indent").setup {}

  use 'terrortylor/nvim-comment'
  require("nvim_comment").setup {}

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }

  use {
    'nvim-telescope/telescope.nvim',
    branch = "0.1.x",
    requires = { 
      "nvim-lua/plenary.nvim",
    }
  }

  -- mason and mason-lspconfig must be loaded before lspconfig
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim'
  }
  require("plugins/mason-config")

  use 'neovim/nvim-lspconfig'
  require("plugins/lsp-config")

  use {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip"
  }
  require("plugins/cmp-config")

  use 'folke/which-key.nvim'
  require("which-key").setup {}
  
  use {
    'akinsho/bufferline.nvim',
    tag = "v3.*",
    requires = 'nvim-tree/nvim-web-devicons',
  }
  require('plugins/bufferline-config')

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)