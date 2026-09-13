local config_root = assert(os.getenv("NEOVIM_CONFIG_ROOT"))
local check_root = assert(os.getenv("NEOVIM_CHECK_ROOT"))

local function assert_attached(server, path)
	vim.cmd.edit(vim.fn.fnameescape(path))
	local attached = vim.wait(30000, function()
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			if client.name == server then
				return true
			end
		end
		return false
	end, 50)
	assert(attached, server .. " did not attach to " .. path)
end

local function assert_capture(buf, row, col, expected)
	local found = vim.wait(1000, function()
		for _, capture in ipairs(vim.inspect_pos(buf, row, col, { treesitter = true }).treesitter) do
			if capture.capture == expected then
				return true
			end
		end
		return false
	end, 20)
	assert(found, ("missing @%s capture at %d:%d"):format(expected, row + 1, col))
end

local lsp = require("core.lsp")
assert(vim.lsp.is_enabled("lua_ls"), "lua_ls is not enabled")
assert(not vim.lsp.is_enabled("emmylua_ls"), "emmylua_ls should not be enabled")

local textobject = vim.fn.maparg("af", "o", false, true)
assert(textobject.desc == "select function.outer", "Treesitter function text object is not mapped")

vim.cmd.edit(vim.fn.fnameescape(config_root .. "/nvim/lua/plugins/ui/theme.lua"))
assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()], "Lua Treesitter highlighting is inactive")

local nix_theme_fixture = check_root .. "/theme.nix"
vim.fn.writefile({
	"let",
	"  makePlugin = plugin: plugin;",
	"  result = {",
	"    package = nvim-lspconfig;",
	'    value = builtins.elem "x" [ ];',
	"  };",
	"in makePlugin result.package",
}, nix_theme_fixture)
vim.cmd.edit(vim.fn.fnameescape(nix_theme_fixture))
local nix_buf = vim.api.nvim_get_current_buf()
assert_capture(nix_buf, 1, 2, "function")
assert_capture(nix_buf, 1, 15, "variable.parameter")
assert_capture(nix_buf, 3, 4, "variable.member")
assert_capture(nix_buf, 3, 14, "variable")
assert_capture(nix_buf, 4, 12, "constant.builtin")
assert_capture(nix_buf, 4, 21, "function.builtin")
assert_capture(nix_buf, 6, 3, "function.call")

if os.getenv("NVIM_CHECK_SERVER_BINARIES") == "1" then
	for _, server in ipairs(lsp.servers) do
		local config = vim.lsp.config[server]
		assert(config, "missing LSP config: " .. server)
		if type(config.cmd) == "table" then
			assert(vim.fn.executable(config.cmd[1]) == 1, server .. " executable is missing: " .. config.cmd[1])
		end
	end
end

if os.getenv("NVIM_CHECK_LSP_ATTACH") == "1" then
	local workspace = check_root .. "/workspaces"
	vim.fn.mkdir(workspace .. "/go", "p")
	vim.fn.mkdir(workspace .. "/typescript", "p")
	vim.fn.mkdir(workspace .. "/nix", "p")

	vim.fn.writefile({ "module example.com/neovimconfig-check", "", "go 1.24" }, workspace .. "/go/go.mod")
	vim.fn.writefile({ "package main", "", "func main() {}" }, workspace .. "/go/main.go")
	vim.fn.writefile({ "{}" }, workspace .. "/typescript/package.json")
	vim.fn.writefile({ '{ "compilerOptions": { "strict": true } }' }, workspace .. "/typescript/tsconfig.json")
	vim.fn.writefile({ "const answer: number = 42" }, workspace .. "/typescript/index.ts")
	vim.fn.writefile({ "{ }" }, workspace .. "/nix/flake.nix")

	assert_attached("lua_ls", config_root .. "/nvim/lua/plugins/ui/theme.lua")
	vim.wait(5000, function()
		return false
	end, 50)
	for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
		assert(diagnostic.code ~= "unresolved-require", diagnostic.message)
	end

	assert_attached("gopls", workspace .. "/go/main.go")
	assert_attached("ts_ls", workspace .. "/typescript/index.ts")
	assert_attached("nixd", workspace .. "/nix/flake.nix")
	local nixd = vim.lsp.get_clients({ bufnr = 0, name = "nixd" })[1]
	assert(
		nixd and not nixd.server_capabilities.semanticTokensProvider,
		"nixd semantic highlighting should be disabled"
	)
end

vim.g.neovim_runtime_check_passed = true
print("Neovim runtime behavior checks passed.")
