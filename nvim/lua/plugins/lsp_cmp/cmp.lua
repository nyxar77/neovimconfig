require("lz.n").load({
	{
		"nvim-cmp",
		priority = 100,
		event = { "InsertEnter", "CmdlineEnter" },
		before = function()
			for _, dependency in ipairs({
				"luasnip",
				"friendly-snippets",
				"lspkind.nvim",
				"cmp-nvim-lsp",
				"cmp-path",
				"cmp-buffer",
				"cmp-cmdline",
				"cmp_luasnip",
			}) do
				vim.cmd.packadd(dependency)
			end
		end,
		after = function()
			-- cmp sources register from after/plugin, which :packadd does not
			-- source when it runs after startup.
			vim.cmd("runtime! after/plugin/cmp_*.lua")
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

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			vim.keymap.set({ "i", "s" }, "<c-k>", function()
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				end
			end, { desc = "jump forward" })

			vim.keymap.set({ "i", "s" }, "<c-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "jump backward" })
		end,
	},
})
