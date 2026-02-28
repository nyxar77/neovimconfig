return {
	cmd = { "asm-lsp" },

	filetypes = { "s", "asm", "vmasm" },
	root_markers = {
		".git",
		".asm-lsp.toml",
	},
	--[[ on_attach = function(client)
		client.server_capabilities.documentHighlight = false
	end, ]]
	capabilities = vim.lsp.protocol.make_client_capabilities(),
}
