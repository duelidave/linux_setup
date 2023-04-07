vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

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

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'bronson/vim-visual-star-search'
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup()
        end
    }
    use {
        'gelguy/wilder.nvim',
        config = function() require('config/wilder') end,
    }
    -- mason
    use {
        'neovim/nvim-lspconfig',
        requires = {
            use 'williamboman/mason.nvim',
            use 'williamboman/mason-lspconfig.nvim',
            use 'j-hui/fidget.nvim'
        }
    }
    use 'mhartington/formatter.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-lint'
    use 'mfussenegger/nvim-jdtls'
    -- LSP
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
            'onsails/lspkind.nvim',
        },
        config = function() require('config/nvim-cmp') end,
    }
    -- nvim-tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function() require('config/nvim-treesitter') end,
    }
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            'nvim-telescope/telescope-dap.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function() require('config/telescope') end,
    }
    use {
        'simrat39/symbols-outline.nvim',
        config = function()
            require('symbols-outline').setup {
                auto_close = true,
            }
        end
    }
    use 'nvim-lua/plenary.nvim'
    -- colorschema
    use 'crusoexia/vim-monokai'
    use 'itchyny/lightline.vim'
    use 'christoomey/vim-tmux-navigator'
    use 'tpope/vim-sensible'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-rhubarb'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tyru/open-browser.vim'
    use 'andymass/vim-matchup'
    use 'weirongxu/plantuml-previewer.vim'
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {} end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
