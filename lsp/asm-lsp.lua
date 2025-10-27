return {
	cmd = { "asm-lsp" },

	filetypes = { "s", "asm" },
	root_markers = {
		".git",
	},
	--[[ on_attach = function(client)
		client.server_capabilities.documentHighlight = false
	end, ]]
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	--[[ settings = {
    }, ]]
}
