---@type vim.lsp.Config
return {
	cmd = { "biome", "lsp-proxy" },

	filetypes = {
		"astro",
		"css",
		"graphql",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
	},

	workspace_required = true,
	single_file_support = false,

	root_dir = function(bufnr, on_dir)
		local root_markers = {
			"package-lock.json",
			"yarn.lock",
			"pnpm-lock.yaml",
			"bun.lockb",
			"bun.lock",
			"deno.lock",
			".git",
		}

		local project_root = vim.fs.root(bufnr, root_markers)
			or vim.fn.getcwd()

		local filename = vim.api.nvim_buf_get_name(bufnr)

		local biome_config_files = {
			"biome.json",
			"biome.jsonc",
			"package.json",
		}

		local found = vim.fs.find(biome_config_files, {
			path = vim.fs.dirname(filename),
			type = "file",
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]

		if not found then
			return
		end

		on_dir(project_root)
	end,
}
