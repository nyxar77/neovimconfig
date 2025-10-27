return {
	{
		"hrsh7th/nvim-cmp",
		priority = 100,
		lazy = false,
		dependencies = {
			{ "hrsh7th/cmp-path" }, -- if you want path completions
			{ "hrsh7th/cmp-buffer" }, -- Completes words from your current buffer
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "neovim/nvim-lspconfig" },
			{ "VonHeikemen/lsp-zero.nvim" },
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				version = "v2.*",
				event = "InsertEnter",
				config = function()
					--require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{ "saadparwaiz1/cmp_luasnip", after = "LuaSnip", lazy = true }, -- combine luaSnip with nvim-cmp
			{ "rafamadriz/friendly-snippets", lazy = true }, -- pre made snippets
			{ "onsails/lspkind.nvim" }, -- adds icon for completion
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()

			local luasnip = require("luasnip")

			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
				}),
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- jump forward
			vim.keymap.set({ "i", "s" }, "<c-k>", function()
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				end
			end, { desc = "jump forward" })

			-- jump backward
			vim.keymap.set({ "i", "s" }, "<c-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "jump backward" })
		end,
	},
}
