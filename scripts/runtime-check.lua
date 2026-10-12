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
assert(vim.tbl_contains(vim.opt.sessionoptions:get(), "blank"), "normal blank-buffer session behavior was disabled")

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

local notebook_errors = {}
local original_notify = vim.notify
vim.notify = function(message, level, opts)
	if level == vim.log.levels.ERROR then
		table.insert(notebook_errors, tostring(message))
	end
	return original_notify(message, level, opts)
end

local function read_notebook(path)
	return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
end

local function contains(value, expected)
	if type(value) == "string" then
		return value:find(expected, 1, true) ~= nil
	end
	if type(value) == "table" then
		for _, child in pairs(value) do
			if contains(child, expected) then
				return true
			end
		end
	end
	return false
end

local function notebook_has_output(notebook, expected)
	for _, cell in ipairs(notebook.cells or {}) do
		for _, output in ipairs(cell.outputs or {}) do
			if contains(output, expected) then
				return true
			end
		end
	end
	return false
end

local notebook_fixture = check_root .. "/notebook.ipynb"
vim.fn.writefile({
	vim.json.encode({
		cells = {
			{
				cell_type = "markdown",
				id = "intro",
				metadata = vim.empty_dict(),
				source = { "# Notebook smoke test\n" },
			},
			{
				cell_type = "code",
				execution_count = vim.NIL,
				id = "python-test",
				metadata = vim.empty_dict(),
				outputs = {},
				source = {
					"numbers = range(1, 6)\n",
					"squares = [number**2 for number in numbers]\n",
					'print("notebook-e2e:", sum(squares))\n',
					"sum(squares)\n",
					'Path(".")\n',
				},
			},
		},
		metadata = {
			kernelspec = {
				display_name = "Python 3",
				language = "python",
				name = "python3",
			},
		},
		nbformat = 4,
		nbformat_minor = 5,
	}),
}, notebook_fixture)
vim.cmd.edit(vim.fn.fnameescape(notebook_fixture))
local notebook_buf = vim.api.nvim_get_current_buf()
local jupynvim = require("jupynvim")
local Notebook = require("jupynvim.notebook")
local notebook_configured = vim.wait(15000, function()
	return Notebook.get(notebook_buf) ~= nil
		and vim.bo[notebook_buf].buftype == "acwrite"
		and vim.fn.maparg(" nr", "n", false, true).desc == "Run cell"
end, 20)
assert(notebook_configured, "jupynvim did not activate for an ipynb file: " .. vim.inspect({
	notebook = Notebook.get(notebook_buf) ~= nil,
	buftype = vim.bo[notebook_buf].buftype,
	filetype = vim.bo[notebook_buf].filetype,
	keymap = vim.fn.maparg(" nr", "n", false, true),
	errors = notebook_errors,
}))
assert(vim.fn.exists(":JupynvimRunCell") == 2, "jupynvim commands are unavailable")
assert(vim.fn.exists(":MoltenInit") == 0, "the removed Molten stack is still loaded")
assert(vim.bo[notebook_buf].filetype == "python", "the notebook did not expose its Python cells")
assert(
	contains(vim.api.nvim_buf_get_lines(notebook_buf, 0, -1, false), "notebook-e2e"),
	"jupynvim did not render the notebook cells"
)
assert(vim.fn.filereadable(check_root .. "/notebook.md") == 0, "opening an ipynb created a Markdown sidecar")

local basedpyright
assert(
	vim.wait(30000, function()
		basedpyright = vim.lsp.get_clients({ bufnr = notebook_buf, name = "basedpyright" })[1]
		return basedpyright ~= nil
	end, 50),
	"basedpyright did not attach to the native notebook buffer"
)
assert(
	basedpyright:supports_method("textDocument/hover", notebook_buf),
	"basedpyright does not expose hover in the notebook"
)
assert(
	basedpyright:supports_method("textDocument/codeAction", notebook_buf),
	"basedpyright does not expose code actions in the notebook"
)
assert(
	#vim.lsp.get_clients({ bufnr = notebook_buf, name = "basedpyright" }) == 1,
	"more than one basedpyright client attached to the notebook"
)
local severity_overrides = basedpyright.settings.basedpyright.analysis.diagnosticSeverityOverrides
assert(
	severity_overrides.reportUnknownMemberType == "none" and severity_overrides.reportUnusedCallResult == "none",
	"basedpyright's noisy notebook diagnostics were not disabled"
)

local code_line = vim.fn.search([[^sum(squares)$]], "nw")
assert(code_line > 0, "the executable notebook cell was not found")
local notebook_win = vim.api.nvim_get_current_win()
vim.api.nvim_win_set_cursor(notebook_win, { code_line, 0 })
local position = vim.lsp.util.make_position_params(0, basedpyright.offset_encoding)
local hover = basedpyright:request_sync("textDocument/hover", position, 10000, notebook_buf)
assert(
	hover and hover.result and hover.result.contents,
	"basedpyright returned no hover information inside the notebook"
)

vim.lsp.buf.hover({ border = "rounded" })
local hover_win
assert(
	vim.wait(10000, function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if
				win ~= notebook_win
				and vim.api.nvim_win_get_config(win).relative ~= ""
				and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "markdown"
			then
				hover_win = win
				return true
			end
		end
		return false
	end, 50),
	"K's LSP hover path did not open notebook documentation"
)
vim.api.nvim_win_close(hover_win, true)
vim.api.nvim_set_current_win(notebook_win)

local action_line = vim.fn.search([[Path(".")]], "nw")
assert(action_line > 0, "the notebook code-action fixture was not found")
vim.api.nvim_win_set_cursor(notebook_win, { action_line, 0 })
assert(
	vim.wait(30000, function()
		for _, diagnostic in ipairs(vim.diagnostic.get(notebook_buf, { lnum = action_line - 1 })) do
			if diagnostic.code == "reportUndefinedVariable" then
				return true
			end
		end
		return false
	end, 50),
	"basedpyright did not report the notebook's undefined Path symbol"
)
local original_select = vim.ui.select
vim.ui.select = function(items, opts, on_choice)
	for _, item in ipairs(items) do
		local label = opts and opts.format_item and opts.format_item(item) or tostring(item)
		if label:find("from pathlib import Path", 1, true) then
			on_choice(item)
			return
		end
	end
	on_choice(nil)
end
local code_action_map = vim.fn.maparg("gra", "n", false, true)
assert(type(code_action_map.callback) == "function", "the notebook LSP code-action mapping is missing")
code_action_map.callback()
assert(
	vim.wait(10000, function()
		return contains(vim.api.nvim_buf_get_lines(notebook_buf, 0, -1, false), "from pathlib import Path")
	end, 50),
	"the notebook code-action path did not apply basedpyright's Path import"
)
vim.ui.select = original_select

local notebook = Notebook.get(notebook_buf)
assert(
	vim.wait(30000, function()
		return notebook and notebook.kernel_started == true
	end, 50),
	"the notebook kernel did not become ready"
)
local execution_line = vim.fn.search("notebook-e2e:", "nw")
assert(execution_line > 0, "the executable notebook cell disappeared after the code action")
vim.api.nvim_win_set_cursor(notebook_win, { execution_line, 0 })
jupynvim.run_cell(notebook_buf, { advance = false })
assert(
	vim.wait(15000, function()
		return notebook_has_output(notebook, "notebook-e2e: 55")
	end, 50),
	"executing the native notebook cell did not produce output"
)
vim.cmd.write()
local saved_notebook = read_notebook(notebook_fixture)
assert(saved_notebook.nbformat == 4, "jupynvim did not save valid nbformat 4 JSON")
assert(notebook_has_output(saved_notebook, "notebook-e2e: 55"), "the executed output was not written to ipynb")
assert(vim.fn.filereadable(check_root .. "/notebook.md") == 0, "saving an ipynb created a Markdown sidecar")

jupynvim.stop_kernel(notebook_buf)
vim.cmd("bdelete!")
vim.cmd.edit(vim.fn.fnameescape(notebook_fixture))
local reopened_buf = vim.api.nvim_get_current_buf()
assert(
	vim.wait(5000, function()
		local reopened = Notebook.get(reopened_buf)
		return reopened and notebook_has_output(reopened, "notebook-e2e: 55")
	end, 20),
	"the notebook output did not survive reopening"
)

local session_fixture = check_root .. "/notebook-session.vim"
require("auto-session").run_cmds("pre_save", notebook_fixture)
assert(vim.bo[reopened_buf].buftype == "", "the notebook was not prepared for :mksession")
vim.cmd("mksession! " .. vim.fn.fnameescape(session_fixture))
require("auto-session").run_cmds("post_save", notebook_fixture)
assert(vim.bo[reopened_buf].buftype == "acwrite", "the notebook buftype was not restored after :mksession")
local session_lines = vim.fn.readfile(session_fixture)
assert(contains(session_lines, "edit " .. notebook_fixture), "the session does not reopen the notebook with :edit")
assert(
	not contains(session_lines, "file " .. notebook_fixture),
	"the session restores the notebook as a named empty buffer"
)
jupynvim.stop_kernel(reopened_buf)

vim.cmd("bwipeout!")
vim.cmd.enew()
vim.cmd("file " .. vim.fn.fnameescape(notebook_fixture))
assert(Notebook.get(0) == nil, "the broken-session fixture unexpectedly initialised jupynvim")
require("auto-session").run_cmds("post_restore", notebook_fixture)
assert(
	vim.wait(15000, function()
		local restored = Notebook.get(0)
		return restored and contains(vim.api.nvim_buf_get_lines(0, 0, -1, false), "notebook-e2e")
	end, 20),
	"the post-restore hook did not recover a named empty notebook buffer"
)
jupynvim.stop_kernel(0)

vim.cmd("bwipeout!")
vim.cmd.enew()
vim.cmd("badd " .. vim.fn.fnameescape(notebook_fixture))
assert(vim.api.nvim_buf_get_name(0) == "", "the omitted-window fixture is not an unnamed buffer")
require("auto-session").run_cmds("post_restore", notebook_fixture)
assert(
	vim.wait(15000, function()
		local restored = Notebook.get(0)
		return restored and contains(vim.api.nvim_buf_get_lines(0, 0, -1, false), "notebook-e2e")
	end, 20),
	"the post-restore hook did not recover an omitted notebook window"
)
jupynvim.stop_kernel(0)

vim.notify = original_notify
assert(#notebook_errors == 0, "notebook workflow emitted errors:\n" .. table.concat(notebook_errors, "\n"))

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
