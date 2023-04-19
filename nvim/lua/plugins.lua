local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("christoomey/vim-tmux-navigator")
	use("bronson/vim-visual-star-search")
	use("crusoexia/vim-monokai")
	use("tpope/vim-sleuth")
	use("tpope/vim-surround")
	use({
		"navarasu/onedark.nvim",
		config = function()
			vim.cmd.colorscheme("onedark")
			require("onedark").setup({
				style = "darker",
			})
			require("onedark").load()
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				theme = "onedark",
				componen_separators = "|",
				section_separators = "",
			},
		},
	})
	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- telescope
	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("config/telescope")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		config = function()
			require("config.nvim-treesitter")
		end
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- buffer
	use({
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("config/bufferline")
		end,
		event = "BufWinEnter",
	})

	-- nvim-tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("config/nvimtree")
		end,
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"folke/neodev.nvim",
		},
	})

	use {
		'akinsho/flutter-tools.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup {} -- use defaults
		end
	}

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup()
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lsp-signature-help", "L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip" },
		config = function()
			require("config/nvim-cmp")
		end,
	})

	use {
		"ThePrimeagen/refactoring.nvim",
		config = function()
			require('refactoring').setup({})
		end
	}

	use({ "mfussenegger/nvim-jdtls" })

	---------------------------
	if packer_bootstrap then
		require("packer").sync()
	end
	---------------------------
end)
