local function load_dir(dir)
	local path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
	for file in vim.fs.dir(path) do
		if file:match("%.lua$") and file ~= "init.lua" then
			local mod = dir .. "." .. file:gsub("%.lua$", "")
			local ok, err = pcall(require, mod)
			if not ok then
				vim.notify("Failed to load " .. mod .. "\n" .. err, vim.log.levels.ERROR)
			end
		end
	end
end

load_dir("plugins")
load_dir("plugins.dap")
load_dir("plugins.lsp_cmp")
load_dir("plugins.ui")
