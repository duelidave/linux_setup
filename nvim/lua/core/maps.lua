-- maps.lua
local map = require("me.util").map
map('n', '<Space>', '', {})
vim.g.mapleader = ' '  -- 'vim.g' sets global variables

local options = { noremap = true, silent = true }

-- telescope
map('n','<leader>ff', ':Telescope find_files hidden=true<cr>', options, "Find Files")
map('n','<leader>fg', ':Telescope live_grep<cr>', options, "Grep")
map('n','<leader>fb', ':Telescope buffers<cr>', options, "Find buffer")
map('n','<leader>fh', ':Telescope help_tags<cr>', options, "Help Tags")
map('n','<leader>fm', ':Telescope marks<cr>', options, "Find mark")
map('n','<leader>fr', ':Telescope lsp_references<cr>', options, "Find references (LSP)")
map('n','<leader>fs', ':Telescope lsp_document_symbols<cr>', options, "Find symbols (LSP)")
map('n','<leader>fc', ':Telescope lsp_incoming_calls<cr>', options, "Find incoming calls (LSP)")
map('n','<leader>fo', ':Telescope lsp_outgoing_calls<cr>', options, "Find outgoing calls (LSP)")
map('n','<leader>fi', ':Telescope lsp_implementations<cr>', options, "Find implementations (LSP)")
map('n','<leader>fx', ':Telescope diagnostics bufnr=0<cr>', options)
require("which-key").register({
  f = {
    name = "find",
  },
}, { prefix = "<leader>" })

-- buffers
map('n','<leader>bn', ':bnext<cr>', options, "next buffer")
map('n','<leader>bp', ':bprevious<cr>', options, "prev buffer")
map('n','<leader>bd', ':bd<cr>', options, "delete buffer")
map('n','<leader>bl', ':ls<cr>', options, "list buffers")
require("which-key").register({
  b = {
    name = "buffers",
  },
}, { prefix = "<leader>" })

-- vim-tree
map('n', '<leader>tt', ':NvimTreeToggle<cr>', options)
map('n', '<leader>tr', ':NvimTreeRefresh<cr>', options)
map('n', '<leader>tf', ':NvimTreeFindFile<cr>', options)
require("which-key").register({
  t = {
    name = "tree",
  },
}, { prefix = "<leader>" })


-- trouble
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", options, "Display errors")
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", options, "Display workspace errors")
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", options, "Display document errors")
require("which-key").register({
  x = {
    name = "errors",
  },
}, { prefix = "<leader>" })

-- vim-test
map("n", "<leader>vt", "<cmd>TestNearest<cr>", options, "Test nearest")
map("n", "<leader>vf", "<cmd>TestFile<cr>", options, "Test file")
map("n", "<leader>vs", "<cmd>TestSuite<cr>", options, "Test suite")
map("n", "<leader>vl", "<cmd>TestLast<cr>", options, "Test last")
map("n", "<leader>vg", "<cmd>TestVisit<cr>", options, "Go to test")
require("which-key").register({
  v = {
    name = "test",
  },
}, { prefix = "<leader>" })

-- nvim-dap
map("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", options, "Set breakpoint")
map("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", options, "Set conditional breakpoint")
map("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", options, "Set log point")
map("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", options, "Clear breakpoints")
map("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", options, "List breakpoints")
require("which-key").register({
  b = {
    name = "breakpoints",
  },
}, { prefix = "<leader>" })


map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", options, "Continue")
map("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", options, "Step over")
map("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", options, "Step into")
map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", options, "Step out")
map("n", "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", options, "Disconnect")
map("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", options, "Terminate")
map("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", options, "Open REPL")
map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", options, "Run last")
map("n", "<leader>di", function() require"dap.ui.widgets".hover() end, options, "Variables")
map("n", "<leader>d?", function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end, options, "Scopes")
map("n", "<leader>df", "<cmd>Telescope dap frames<cr>", options, "List frames")
map("n", "<leader>dh", "<cmd>Telescope dap commands<cr>", options, "List commands")
require("which-key").register({
  d = {
    name = "debug",
  },
}, { prefix = "<leader>" })


-- vim.cmd([[
-- " press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
-- imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
-- " -1 for jumping backwards.
-- inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
--
-- snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
-- snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
--
-- " For changing choices in choiceNodes (not strictly necessary for a basic setup).
-- imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
-- smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
-- ]])
