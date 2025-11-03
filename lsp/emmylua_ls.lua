local function is_in_nvimconfig()
	return (string.find(vim.fn.expand("%:p"), vim.fn.expand("~/.config/nvim"), 1, true)) ~= nil
end

return {
	cmd = { "emmylua_ls" },
	filetypes = { "lua" },
	-- capabilities = vim.lsp.protocol.make_client_capabilities(),
	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
	},
	settings = (function()
		if is_in_nvimconfig() then
			return {
				Lua = {
					diagnostics = { globals = { "vim", "require" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				},
			}
		end
		return {}
	end)(),
}
