local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local luasnip = require("luasnip")
local compare = require "cmp.config.compare"
local lspkind = require("lspkind")

local function border(hl_name)
	return {
		{ "╭", hl_name },
		{ "─", hl_name },
		{ "╮", hl_name },
		{ "│", hl_name },
		{ "╯", hl_name },
		{ "─", hl_name },
		{ "╰", hl_name },
		{ "│", hl_name },
	}
end

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)
cmp.setup({
	window = {
		completion = {
			border = border "CmpBorder",
			-- winhighlight = "CursorLine:PmenuSel,Search:None",
			winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
		},
		documentation = true,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	view = {
		entries = { name = 'custom', selection_order = 'near_cursor' }
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
		["<C-y>"] = cmp.mapping.confirm(),
		["<C-s>"] = cmp.mapping.complete({
			config = {
				sources = {
					{ name = 'copilot' },
				}
			}
		}),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
	}),
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	},
	sources = {
		-- order matters
		{ name = "gh_issues" },
		{
			name = "copilot",
			-- keyword_pattern = "."
		},
		{
			name = 'nvim_lsp',
		},
		{
			name = 'luasnip',
			entry_filter = function(entry)
				return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
			end
		},
		{
			name = 'nvim_lua',
		},
		{
			name = 'buffer',
			keyword_length = 5,
			max_item_count = 3,
		},
		{
			name = 'git',
		},
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			compare.exact,
			require("copilot_cmp.comparators").prioritize,
			require("copilot_cmp.comparators").score,
			compare.offset,
			compare.scopes,
			compare.score,
			compare.recently_used,
			compare.locality,
			compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
		},
	},
	formatting = {
		format = lspkind.cmp_format {
			with_text = true,
			menu = {
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				luasnip = "[snip]",
				buffer = "[buf]",
				gh_issues = "[issues]",
			}
		}
		-- fields = { "kind", "abbr", "menu" },
		-- format = function(entry, vim_item)
		-- 	if entry.source.name == "copilot" then
		-- 		vim_item.kind_hl_group = "CmpItemKindCopilot"
		-- 	end
		--
		-- 	-- NOTE: order matters
		-- 	vim_item.menu = ({
		-- 		nvim_lsp = "",
		-- 		nvim_lua = "",
		-- 		luasnip = "",
		-- 		buffer = "",
		-- 		path = "",
		-- 		emoji = "",
		-- 	})[entry.source.name]
		-- 	return vim_item
		-- end,
	},
	formatters = {
		label = require("copilot_cmp.format").format_label_text,
		insert_text = require("copilot_cmp.format").remove_existing,
		preview = require("copilot_cmp.format").deindent,
	},
	experimental = {
		native_menu = false,
		ghost_text = false,
	},
})

require "cmp".setup.cmdline({ "/", "?" }, {
	mapping = require "cmp".mapping.preset.cmdline(),
	sources = {
		{
			name = "buffer",
			option = { keyword_pattern = [[\k\+]] }
		},
		{ name = "buffer-lines" }
	}
})

require("cmp_git").setup({
	-- As above
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.sort_text,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.kind,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})
