require("lz.n").load({
	{
		"nvim-ufo",
		event = "BufReadPost",
		after = function()
			local language_servers = vim.lsp.get_clients()
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
	},
})
