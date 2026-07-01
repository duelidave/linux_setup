return {
    -- Grundlegende Abhängigkeiten
    { "nvim-lua/plenary.nvim",                 lazy = false },
    { "christoomey/vim-tmux-navigator" },
    { "bronson/vim-visual-star-search" },
    { "crusoexia/vim-monokai" },
    { "tpope/vim-sleuth" },
    { "tpope/vim-surround" },

    -- Colorscheme — eagerly mit hoher Priorität laden
    {
        "savq/melange-nvim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd.colorscheme("melange")
        end,
    },

    -- Statuslinie
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = "nightfly",
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },

    -- Kommentare
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Telescope
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("config/telescope")
        end,
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter (commit vor nvim-0.10-Pflicht)
    {
        "nvim-treesitter/nvim-treesitter",
        commit = "v0.9.2",
        build = ":TSUpdate",
        config = function()
            require("config.nvim-treesitter")
        end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        event = "BufWinEnter",
        config = function()
            require("config/bufferline")
        end,
    },

    -- Dateibaum
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("config/nvimtree")
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "folke/neodev.nvim",
        },
    },
    {
        "onsails/lspkind.nvim",
        config = function()
            require("lspkind")
        end,
    },

    -- Flutter
    {
        "akinsho/flutter-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        },
        config = function()
            require("flutter-tools").setup({})
        end,
    },

    -- Formatter / Linter (none-ls = aktiver Fork von null-ls)
    {
        "nvimtools/none-ls.nvim",
        config = function()
            require("null-ls").setup()
        end,
    },


    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "tzachar/cmp-fuzzy-buffer",
            "tzachar/fuzzy.nvim",
            "petertriho/cmp-git",
        },
        config = function()
            require("config/nvim-cmp")
        end,
    },

    -- Refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        lazy = false,
        dependencies = {
            "lewis6991/async.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("refactoring").setup({})
        end,
    },

    -- Java
    { "mfussenegger/nvim-jdtls" },
}
