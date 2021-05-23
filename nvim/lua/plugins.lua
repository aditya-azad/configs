local execute = vim.api.nvim_command
local fn = vim.fn

-- Auto install packer if not exists
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end
execute 'packadd packer.nvim'
execute 'autocmd BufWritePost plugins.lua PackerCompile' -- Autocompile on change

-- Plugins
require('packer').startup(function()
  -- Utils
  use 'wbthomason/packer.nvim' 
  use 'arithran/vim-delete-hidden-buffers'

  -- Visuals
  use {'dracula/vim', as = 'dracula'}
  use 'sheerun/vim-polyglot'
  use 'norcalli/nvim-colorizer.lua'
  use 'nvim-treesitter/nvim-treesitter'
  use 'kyazdani42/nvim-web-devicons'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

  -- Navigation enhancements
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-media-files.nvim'

  -- Code enhancements
  use 'tpope/vim-fugitive'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'

  -- Language specific
  use 'jceb/vim-orgmode'
  use 'vim-scripts/utl.vim'
end)

require 'plugins.nvimTree'
require 'plugins.telescope'
require 'plugins.fugitive'
require 'plugins.lsp'
require 'plugins.compe'
require 'plugins.deleteHiddenBuffers'