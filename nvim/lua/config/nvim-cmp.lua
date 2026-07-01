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

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

cmp.setup({
	window = {
		completion = {
			border = border "CmpBorder",
			winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
		},
		documentation = true,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
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
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
	}),
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{
			name = 'luasnip',
			entry_filter = function(entry)
				return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
			end
		},
		{ name = 'nvim_lua' },
		{
			name = 'buffer',
			keyword_length = 5,
			max_item_count = 3,
		},
		{ name = 'git' },
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			compare.exact,
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
				luasnip   = "[snip]",
				buffer    = "[buf]",
			}
		}
	},
	experimental = {
		native_menu = false,
		ghost_text = false,
	},
})

require("cmp").setup.cmdline({ "/", "?" }, {
	mapping = require("cmp").mapping.preset.cmdline(),
	sources = {
		{
			name = "buffer",
			option = { keyword_pattern = [[\k\+]] }
		},
	}
})

require("cmp_git").setup({
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
