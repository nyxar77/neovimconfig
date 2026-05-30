require("lz.n").load({
	{
		"conform.nvim",
		event = "BufWritePre",
		keys = {
			{
				"<leader>ff",
				function()
					require("conform").format({ lsp_fallback = true, async = true })
				end,
				desc = "format buffer",
			},
		},
		after = function()
			require("conform").setup({
				formatters = {
					biome = {
						cmd = "biome",
						append_args = { "format", "--write" },
					},
				},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt" },
					javascript = { "biome" },
					typescript = { "biome" },
					javascriptreact = { "biome" },
					typescriptreact = { "biome" },
					json = { "biome" },
					css = { "biome" },
					yaml = { "yamlfmt" },
					graphql = { "prettier" },
					markdown = { "prettier" },
					nix = { "alejandra" },
					hypr = { "hyprls" },
					cpp = { "lsp" },
					c = { "lsp" },
					sh = { "shfmt" },
					["_"] = { "lsp" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})
		end,
	},
})
