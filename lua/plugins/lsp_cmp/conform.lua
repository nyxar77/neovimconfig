---@type LazyPlugin
return {
	"stevearc/conform.nvim",
	branch = "master",
	lazy = true,
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
	config = function()
		local conform = require("conform")
		conform.setup({
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
				-- html = { "prettier" },
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
}
