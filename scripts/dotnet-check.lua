-- Smoke check the .NET editor setup with one small local project.
local root = assert(os.getenv("NEOVIM_CHECK_ROOT")) .. "/dotnet"
vim.fn.mkdir(root, "p")
vim.fn.writefile({
	'<Project Sdk="Microsoft.NET.Sdk">',
	'  <PropertyGroup><TargetFramework>net10.0</TargetFramework></PropertyGroup>',
	'</Project>',
}, root .. "/Fixture.csproj")
local source = root .. "/Program.cs"
vim.fn.writefile({ "class Program{static int Answer()=>42;}" }, source)

for _, binary in ipairs({ "dotnet", "csharpier" }) do
	assert(vim.fn.executable(binary) == 1, "missing executable: " .. binary)
end
assert(vim.fn.filereadable(vim.env.EASY_DOTNET_ROSLYN_DLL_PATH or "") == 1, "Nix Roslyn DLL is missing")
local restored = vim.system({ "dotnet", "restore", "Fixture.csproj" }, { cwd = root, text = true }):wait(120000)
assert(restored.code == 0, "dotnet restore failed: " .. (restored.stderr or ""))

vim.cmd.edit(source)
local buf = vim.api.nvim_get_current_buf()
assert(package.loaded["easy-dotnet"], "opening C# did not load easy-dotnet")
assert(vim.fn.exists(":Dotnet") == 2, "Dotnet command is missing")
assert(vim.treesitter.highlighter.active[buf], "C# Tree-sitter highlighting is inactive")
assert(vim.wait(60000, function()
	local client = vim.lsp.get_clients({ bufnr = buf, name = "easy_dotnet" })[1]
	return client and client.initialized
end, 50), "Roslyn did not attach")

require("lz.n").trigger_load("conform.nvim")
vim.cmd.write()
assert(#vim.fn.readfile(source) > 1, "format-on-save did not format the C# file")
local formatted = vim.system({ "csharpier", "check", source }, { cwd = root, text = true }):wait(30000)
assert(formatted.code == 0, "CSharpier rejected the saved file: " .. (formatted.stderr or ""))

vim.g.neovim_dotnet_check_passed = true
print(".NET editor smoke check passed.")
