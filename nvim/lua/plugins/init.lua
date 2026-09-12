local load_errors = {}

local function load_dir(dir)
	local path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
	local files = {}

	for file in vim.fs.dir(path) do
		if file:match("%.lua$") and file ~= "init.lua" then
			table.insert(files, file)
		end
	end

	table.sort(files)
	for _, file in ipairs(files) do
		local mod = dir .. "." .. file:gsub("%.lua$", "")
		local ok, err = pcall(require, mod)
		if not ok then
			table.insert(load_errors, mod .. ": " .. err)
		end
	end
end

load_dir("plugins")
load_dir("plugins.dap")
load_dir("plugins.lsp_cmp")
load_dir("plugins.ui")

if #load_errors > 0 then
	error("Failed to load configuration modules:\n" .. table.concat(load_errors, "\n"), 0)
end
