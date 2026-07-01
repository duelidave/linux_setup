-- maps.lua
vim.keymap.set('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- telescope (lazy-geladen: Plugin wird erst beim ersten Aufruf benötigt)
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end,  { desc = "[F]ind [F]iles" })
vim.keymap.set('n', '<leader>fe', function() require('telescope.builtin').oldfiles() end,    { desc = "[F]ind recently opened fil[e]s" })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end,   { desc = "[F]ind [G]rep" })
vim.keymap.set('n', '<leader>fw', function() require('telescope.builtin').grep_string() end, { desc = "[F]ind [W]ord" })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end,     { desc = "[F]ind [B]uffers" })
vim.keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end,   { desc = "[F]ind [H]elp tags" })

-- LSP Diagnostics
vim.keymap.set("n", "<leader>da", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

-- Refactoring (Telescope-Extension)
vim.api.nvim_set_keymap(
    "v",
    "<leader>rr",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true }
)

-- Buffer-Navigation
vim.keymap.set('n', '<leader>bn', ':bnext<cr>',     { desc = "next buffer" })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = "prev buffer" })
vim.keymap.set('n', '<leader>bd', ':bd<cr>',        { desc = "delete buffer" })
vim.keymap.set('n', '<leader>bl', ':ls<cr>',        { desc = "list buffers" })

-- Dateibaum
vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<cr>',         { desc = "[T]ree [T]oggle" })
vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFileToggle<cr>', { desc = "[T]ree [F]ind toggle" })

-- which-key Gruppen — erst registrieren wenn Plugin bereit ist
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local ok, wk = pcall(require, "which-key")
        if not ok then return end
        wk.add({
            { "<leader>f", group = "telescope" },
            { "<leader>b", group = "buffers" },
            { "<leader>t", group = "tree" },
        })
    end,
})
