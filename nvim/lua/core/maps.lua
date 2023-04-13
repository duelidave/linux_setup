-- maps.lua
vim.keymap.set('n', '<Space>', '', {})
vim.g.mapleader = ' '  -- 'vim.g' sets global variables

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "[F]ind [F]iles"})
vim.keymap.set('n', '<leader>fe', builtin.oldfiles, {desc = "[F]ind recently opened fil[e]s"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "[F]ind [G]rep"})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {desc = "[F]ind [W]ord"})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = "[F]ind [B]uffers"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "[F]ind [H]elp tags"})
require("which-key").register({
  f = {
    name = "telescope",
  },
}, { prefix = "<leader>" })

-- LSP
-- Global mappings.
vim.keymap.set("n", "<leader>da", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

-- buffers
vim.keymap.set('n','<leader>bn', ':bnext<cr>', {desc = "next buffer"})
vim.keymap.set('n','<leader>bp', ':bprevious<cr>', {desc = "prev buffer"})
vim.keymap.set('n','<leader>bd', ':bd<cr>', {desc = "delete buffer"})
vim.keymap.set('n','<leader>bl', ':ls<cr>', {desc = "list buffers"})
require("which-key").register({
  b = {
    name = "buffers",
  },
}, { prefix = "<leader>" })

-- nvim-tree
vim.keymap.set('n','<leader>tt', ':NvimTreeToggle<cr>', {desc = "[T]ree [T]oggle"})
vim.keymap.set('n','<leader>tf', ':NvimTreeFindFileToggle<cr>', {desc = "[T]ree [F]ind toggle"})
require("which-key").register({
  t = {
    name = "tree",
  }
}, { prefix = "<leader>" })
-- trouble

-- vim-test

-- nvim-dap

