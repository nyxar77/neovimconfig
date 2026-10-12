-- basedpyright advertises notebookDocumentSync, but jupynvim 0.4.5 does not
-- translate interactive LSP requests (hover/code actions) to cell URIs yet.
-- Keep basedpyright on jupynvim's line-preserving Python buffer instead.
vim.lsp.config("basedpyright", {
	on_init = function(client)
		client.server_capabilities.notebookDocumentSync = nil
	end,
	settings = {
		basedpyright = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportUnknownMemberType = "none",
					reportUnusedCallResult = "none",
				},
			},
		},
	},
})

require("jupynvim").setup({
	log_level = "info",
	image_renderer = "placeholder",
	keymaps = {
		run_advance_alt = false,
		run_stay = "<leader>nr",
	},
})
