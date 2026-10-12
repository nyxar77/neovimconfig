-- Exercise the configured editor and real tools, including failure paths.
local root = assert(os.getenv("NEOVIM_CHECK_ROOT")) .. "/dotnet"
local failures = {}
local original_notify = vim.notify
vim.v.errmsg = ""
vim.notify = function(message, level, opts)
	if level == vim.log.levels.ERROR then
		table.insert(failures, tostring(message))
	end
	return original_notify(message, level, opts)
end

local function wait_for(label, predicate, timeout)
	assert(vim.wait(timeout or 60000, predicate, 50), label .. " timed out\n" .. table.concat(failures, "\n"))
end

local function write(path, lines)
	vim.fn.mkdir(vim.fs.dirname(root .. "/" .. path), "p")
	vim.fn.writefile(lines, root .. "/" .. path)
end

local function command(args)
	local result = vim.system(args, { cwd = root, text = true }):wait(120000)
	assert(result.code == 0, table.concat(args, " ") .. " failed\n" .. (result.stdout or "") .. (result.stderr or ""))
	return result.stdout
end

assert(not package.loaded["easy-dotnet"], "easy-dotnet loaded before a .NET file or command")
for _, binary in ipairs({ "dotnet", "dotnet-easydotnet", "csharpier", "netcoredbg" }) do
	assert(vim.fn.executable(binary) == 1, "missing executable: " .. binary)
end
assert(vim.fn.filereadable(vim.env.EASY_DOTNET_ROSLYN_DLL_PATH or "") == 1, "Nix Roslyn DLL is missing")

write("Library/Library.csproj", {
	'<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><TargetFramework>net10.0</TargetFramework></PropertyGroup></Project>',
})
local calculator = {
	"namespace Fixture;",
	"public static class Calculator",
	"{",
	"    public static int Add(int left, int right)",
	"    {",
	"        return left + right;",
	"    }",
	"}",
}
write("Library/Calculator.cs", calculator)
write("App/App.csproj", {
	'<Project Sdk="Microsoft.NET.Sdk">',
	"  <PropertyGroup><TargetFramework>net10.0</TargetFramework><OutputType>Exe</OutputType></PropertyGroup>",
	'  <ItemGroup><ProjectReference Include="../Library/Library.csproj" /></ItemGroup>',
	"</Project>",
})
local program = {
	"using System;",
	"using Fixture;",
	"class Program",
	"{",
	"    static void Main()",
	"    {",
	"        int answer = Calculator.Add(20, 22);",
	'        Console.WriteLine($"dotnet-e2e: {answer}");',
	"    }",
	"}",
}
write("App/Program.cs", program)
write("Tests/Tests.csproj", {
	'<Project Sdk="Microsoft.NET.Sdk">',
	"  <PropertyGroup><TargetFramework>net10.0</TargetFramework><IsTestProject>true</IsTestProject></PropertyGroup>",
	'  <ItemGroup><ProjectReference Include="../Library/Library.csproj" />',
	'    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.14.1" />',
	'    <PackageReference Include="xunit" Version="2.9.3" />',
	'    <PackageReference Include="xunit.runner.visualstudio" Version="3.1.4" />',
	"  </ItemGroup>",
	"</Project>",
})
local test_source = {
	"using Xunit;",
	"public class CalculatorTests",
	"{",
	"    [Fact]",
	"    public void AddsNumbers() => Assert.Equal(42, Fixture.Calculator.Add(20, 22));",
	"}",
}
write("Tests/CalculatorTests.cs", test_source)
command({ "dotnet", "new", "sln", "--name", "Fixture", "--format", "sln" })
command({ "dotnet", "sln", "Fixture.sln", "add", "Library/Library.csproj", "App/App.csproj", "Tests/Tests.csproj" })
command({ "dotnet", "restore", "Fixture.sln" })
-- Pin the fixture SDK so tool wrappers must respect a project's global.json.
local sdk = vim.trim(command({ "dotnet", "--version" }))
write("global.json", { vim.json.encode({ sdk = { version = sdk, rollForward = "disable" } }) })

vim.cmd.cd(root)
vim.cmd.edit(root .. "/App/Program.cs")
local app_buf = vim.api.nvim_get_current_buf()
assert(package.loaded["easy-dotnet"], "opening C# did not load easy-dotnet")
assert(vim.fn.exists(":Dotnet") == 2, "Dotnet command is missing")
assert(vim.treesitter.highlighter.active[app_buf], "C# Tree-sitter highlighting is inactive")
local client
wait_for("Roslyn attachment", function()
	client = vim.lsp.get_clients({ bufnr = app_buf, name = "easy_dotnet" })[1]
	return client and client.initialized
end)
assert(#vim.lsp.get_clients({ bufnr = app_buf, name = "easy_dotnet" }) == 1, "duplicate Roslyn clients")

local function position(row, col)
	return { textDocument = { uri = vim.uri_from_bufnr(app_buf) }, position = { line = row, character = col } }
end
local function request(method, params)
	local response, err = client:request_sync(method, params, 15000, app_buf)
	assert(response and not response.err, method .. ": " .. vim.inspect(err or response))
	return response.result
end
local definition
wait_for("cross-project definition", function()
	definition = request("textDocument/definition", position(6, 34))
	local first = definition and definition[1]
	return first and (first.uri or first.targetUri):match("/Library/Calculator.cs$")
end)
local hover = request("textDocument/hover", position(6, 34))
assert(hover and vim.inspect(hover):find("Add", 1, true), "hover did not describe Add")
local refs = position(6, 34)
refs.context = { includeDeclaration = true }
local references = request("textDocument/references", refs)
assert(references and #references >= 2, "references did not include declaration and caller")
local rename = position(6, 34)
rename.newName = "Sum"
local edits = request("textDocument/rename", rename)
assert(edits and vim.inspect(edits):find("Sum", 1, true), "rename produced no workspace edit")
vim.lsp.util.apply_workspace_edit(edits, client.offset_encoding)
assert(
	table.concat(vim.api.nvim_buf_get_lines(app_buf, 0, -1, false), "\n"):find("Calculator.Sum", 1, true),
	"rename did not change the caller"
)
local library_buf = vim.fn.bufnr(root .. "/Library/Calculator.cs")
assert(
	library_buf >= 0
		and table.concat(vim.api.nvim_buf_get_lines(library_buf, 0, -1, false), "\n"):find("int Sum", 1, true),
	"rename did not change the definition"
)
vim.api.nvim_buf_set_lines(library_buf, 0, -1, false, calculator)
vim.api.nvim_buf_set_lines(app_buf, 0, -1, false, program)
vim.bo[library_buf].modified = false
vim.bo[app_buf].modified = false
local tests_buf = vim.fn.bufnr(root .. "/Tests/CalculatorTests.cs")
if tests_buf >= 0 and vim.api.nvim_buf_is_loaded(tests_buf) then
	vim.api.nvim_buf_set_lines(tests_buf, 0, -1, false, test_source)
	vim.bo[tests_buf].modified = false
end

-- A real completion request after an incomplete member access.
vim.api.nvim_buf_set_lines(app_buf, 7, 8, false, { "        Console." })
local completion
wait_for("C# completion", function()
	completion = request("textDocument/completion", position(7, 16))
	for _, item in ipairs(completion and (completion.items or completion) or {}) do
		if item.label:find("WriteLine", 1, true) then
			return true
		end
	end
	return false
end)
vim.api.nvim_buf_set_lines(app_buf, 0, -1, false, program)
vim.api.nvim_buf_set_lines(app_buf, 7, 8, false, { "        MissingSymbol();" })
wait_for("undefined-symbol diagnostic", function()
	for _, diagnostic in ipairs(vim.diagnostic.get(app_buf)) do
		if tostring(diagnostic.code) == "CS0103" and diagnostic.message:find("MissingSymbol", 1, true) then
			return true
		end
	end
end)
vim.api.nvim_buf_set_lines(app_buf, 0, -1, false, program)
wait_for("diagnostic clearing", function()
	for _, diagnostic in ipairs(vim.diagnostic.get(app_buf)) do
		if diagnostic.message:find("MissingSymbol", 1, true) then
			return false
		end
	end
	return true
end)

-- Request and apply a real Roslyn code action for a missing using directive.
vim.api.nvim_buf_set_lines(app_buf, 7, 8, false, { '        File.WriteAllText("unused", "value");' })
local actions
wait_for("import code action", function()
	actions = request("textDocument/codeAction", {
		textDocument = { uri = vim.uri_from_bufnr(app_buf) },
		range = { start = { line = 7, character = 8 }, ["end"] = { line = 7, character = 12 } },
		context = { diagnostics = {} },
	})
	for _, action in ipairs(actions or {}) do
		if action.title:find("using System.IO", 1, true) then
			local resolved = action.edit and action or request("codeAction/resolve", action)
			assert(resolved.edit, "import action resolved without an edit")
			vim.lsp.util.apply_workspace_edit(resolved.edit, client.offset_encoding)
			return true
		end
	end
	return false
end)
assert(
	table.concat(vim.api.nvim_buf_get_lines(app_buf, 0, -1, false), "\n"):find("using System.IO;", 1, true),
	"code action did not insert the import"
)
vim.api.nvim_buf_set_lines(app_buf, 0, -1, false, program)

-- Both the existing manual mapping and save hook must run CSharpier.
vim.api.nvim_buf_set_lines(app_buf, 0, -1, false, { table.concat(program, " ") })
local format_map = vim.fn.maparg(" ff", "n", false, true)
assert(type(format_map.callback) == "function", "format mapping is missing")
format_map.callback()
wait_for("manual CSharpier formatting", function()
	return vim.api.nvim_buf_line_count(app_buf) > 5
end)
vim.api.nvim_buf_set_lines(app_buf, 0, -1, false, { table.concat(program, " ") })
vim.cmd.write()
assert(#vim.fn.readfile(root .. "/App/Program.cs") > 5, "format-on-save did not format the disk file")
assert(command({ "csharpier", "check", "App/Program.cs" }), "CSharpier rejected the saved file")
print("PASS: C# LSP, Tree-sitter, code actions and formatting")

-- Select real Telescope entries automatically; the picker still opens normally.
local picker_timer = vim.uv.new_timer()
picker_timer:start(
	50,
	50,
	vim.schedule_wrap(function()
		if vim.bo.filetype == "TelescopePrompt" then
			local picker = require("telescope.actions.state").get_current_picker(vim.api.nvim_get_current_buf())
			if picker and picker.manager and picker.manager:num_results() > 0 then
				require("telescope.actions").select_default(vim.api.nvim_get_current_buf())
			end
		end
	end)
)
local manager = require("easy-dotnet.terminal.manager")
local function plugin_command(cmd, expected_exit, expected_output)
	vim.cmd("stopinsert")
	vim.api.nvim_set_current_buf(app_buf)
	local old_buffers = {}
	for _, tab in ipairs(manager.get_all()) do
		old_buffers[tab.buf] = true
	end
	vim.cmd(cmd)
	local finished
	wait_for(cmd, function()
		for _, tab in ipairs(manager.get_all()) do
			if not old_buffers[tab.buf] and tab.last_status == "finished" then
				finished = tab
				return true
			end
		end
	end, 120000)
	local output = table.concat(vim.api.nvim_buf_get_lines(finished.buf, 0, -1, false), "\n")
	assert(
		finished.last_exit_code == expected_exit,
		cmd .. " exit " .. tostring(finished.last_exit_code) .. "\n" .. output
	)
	assert(
		output:find(expected_output, 1, true),
		cmd .. " missing expected output: " .. expected_output .. "\n" .. output
	)
	print("PASS: " .. cmd .. " (exit " .. expected_exit .. ")")
end
plugin_command("Dotnet build solution", 0, "Build succeeded")
plugin_command("Dotnet run", 0, "dotnet-e2e: 42")
plugin_command("Dotnet test solution", 0, "Passed:     1")
write(
	"Tests/CalculatorTests.cs",
	vim.tbl_map(function(line)
		return line:gsub("Assert.Equal%(42,", "Assert.Equal(43,")
	end, test_source)
)
plugin_command("Dotnet test solution", 1, "Failed:     1")
write("Tests/CalculatorTests.cs", test_source)
write("Library/Broken.cs", { "this is deliberately invalid C#;" })
plugin_command("Dotnet build solution", 1, "Build FAILED")
vim.fn.delete(root .. "/Library/Broken.cs")
plugin_command("Dotnet build solution", 0, "Build succeeded")

vim.cmd("stopinsert")
vim.api.nvim_set_current_buf(app_buf)
vim.cmd("Dotnet testrunner")
local runner = require("easy-dotnet.test-runner.state")
local render = require("easy-dotnet.test-runner.render")
local test_node
wait_for("test tree discovery", function()
	for _, node in pairs(runner.nodes) do
		if node.displayName:find("AddsNumbers", 1, true) and node.type.type == "TestMethod" then
			test_node = node
			return runner.initialized and not runner.runner_status.isLoading
		end
	end
	return false
end, 120000)
assert(render.win and vim.api.nvim_win_is_valid(render.win), "test tree window did not open")
vim.api.nvim_set_current_win(render.win)
local run_all = vim.fn.maparg(" R", "n", false, true)
assert(type(run_all.callback) == "function", "test runner run-all key missing")
run_all.callback()
wait_for("test tree results", function()
	local node = runner.nodes[test_node.id]
	return node and node.status and node.status.type == "Passed" and not runner.runner_status.isLoading
end, 120000)
assert(runner.runner_status.totalPassed == 1 and runner.runner_status.totalFailed == 0, "incorrect test tree counts")
render.hide()
print("PASS: test tree discovery and execution")

-- Start via the existing DAP mapping and stop on a real source breakpoint.
vim.cmd("stopinsert")
vim.api.nvim_set_current_buf(app_buf)
local line = vim.fn.search("Console.WriteLine", "nw")
assert(line > 0, "debug breakpoint line missing")
vim.api.nvim_win_set_cursor(0, { line, 0 })
vim.fn.maparg(" db", "n", false, true).callback()
local dap = require("dap")
local stopped, output, exited = nil, {}, false
dap.listeners.after.event_stopped.dotnet_check = function(_, body)
	stopped = body
end
dap.listeners.after.event_output.dotnet_check = function(_, body)
	table.insert(output, body.output or "")
end
dap.listeners.after.event_exited.dotnet_check = function(_, body)
	assert(body.exitCode == 0, "debuggee exited unsuccessfully")
	exited = true
end
vim.fn.maparg(" dc", "n", false, true).callback()
wait_for("debugger breakpoint", function()
	return stopped ~= nil and dap.session() and dap.session().current_frame ~= nil
end, 120000)
assert(stopped.reason == "breakpoint", "debugger stopped for " .. tostring(stopped.reason))
assert(dap.session().current_frame.line == line, "debugger stopped on the wrong line")
local evaluated
dap.session():request(
	"evaluate",
	{ expression = "answer", frameId = dap.session().current_frame.id, context = "watch" },
	function(err, result)
		assert(not err, vim.inspect(err))
		evaluated = result
	end
)
wait_for("debugger evaluation", function()
	return evaluated ~= nil
end)
assert(evaluated.result == "42", "debugger evaluated answer as " .. vim.inspect(evaluated))
dap.continue()
wait_for("debugger exit", function()
	return exited and dap.session() == nil
end)
picker_timer:stop()
picker_timer:close()
print("PASS: debugger breakpoint, variable evaluation and clean exit")

-- Expected failing builds/tests are checked above; unexpected editor errors fail.
assert(#failures == 0, "editor errors:\n" .. table.concat(failures, "\n"))
assert(vim.v.errmsg == "", "asynchronous editor error: " .. vim.v.errmsg)
vim.notify = original_notify
vim.g.neovim_dotnet_check_passed = true
print(".NET integration checks passed.")
