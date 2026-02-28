local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

---@type vim.lsp.Config
return {
	cmd = { "neocmakelsp", "stdio" },
	filetypes = { "cmake" },
	root_markers = { ".git", "build", "cmake" },
	single_file_support = true,
	capabilities = capabilities,
	init_options = {
		format = {
			enable = true,
		},
		lint = {
			enable = true,
		},
		scan_cmake_in_package = true,
	},
}
