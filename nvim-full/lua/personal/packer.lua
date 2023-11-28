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

require('packer').startup(function(use)
    use('wbthomason/packer.nvim')
    use('lewis6991/gitsigns.nvim')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('hrsh7th/cmp-nvim-lua')
    use({
        'catppuccin/nvim',
        as = 'catppuccin'
    })
    use({
        'nvim-tree/nvim-tree.lua',
        requires = {
            {'nvim-tree/nvim-web-devicons'}
        }
    })
    use({
        'nvim-telescope/telescope.nvim',
        tag='0.1.2',
        requires = {
            {'nvim-lua/plenary.nvim'}
        }
    })
    use({
        'nvim-treesitter/nvim-treesitter',
        {run = ':TSUpdate'}
    })
    use({
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    })
    use({
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'L3MON4D3/LuaSnip'},
            {'saadparwaiz1/cmp_luasnip'},
            {'rafamadriz/friendly-snippets'}
        }
    })
    if packer_bootstrap then
        require('packer').sync()
    end
end)
