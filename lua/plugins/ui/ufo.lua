return {
	"kevinhwang91/nvim-ufo",
	lazy = true,
	event = "BufReadPost",
	dependencies = { "kevinhwang91/promise-async" },
	config = function()
		-- First setup ufo before setting keymaps
		--[[ local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		} ]]
		local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
		for _, ls in ipairs(language_servers) do
			vim.lsp.config("*", {
				capabilities = {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				},
			})
		end
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
			preview = {
				win_config = {
					border = "rounded",
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
			},
		})
	end,
}
