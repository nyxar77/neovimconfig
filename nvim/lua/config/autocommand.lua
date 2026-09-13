local changeLayout = require("config.changeLayout")

local function augroup(name)
	return vim.api.nvim_create_augroup("nyxar_" .. name, { clear = true })
end

vim.api.nvim_create_user_command("Cheatsheet", function()
	local path = vim.fn.stdpath("config") .. "/doc/cheatsheet.md"
	if vim.fn.filereadable(path) == 0 then
		vim.notify("Cheatsheet not found: " .. path, vim.log.levels.ERROR)
		return
	end

	vim.cmd("tabedit " .. vim.fn.fnameescape(path))
	vim.bo.buflisted = false
	vim.bo.readonly = true
	vim.bo.modifiable = false
	vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = true, silent = true, desc = "Close cheatsheet" })
end, { desc = "Open the Neovim configuration cheatsheet" })

-- set keyboard layout
vim.api.nvim_create_user_command("SetLayout", function(opts)
	local keyboardLayout = opts.args
	if changeLayout.acceptedLayout(keyboardLayout) then
		if changeLayout.savelayout(keyboardLayout) == true then
			local layout = changeLayout.loadlayout()
			vim.g.keyboardLayout = layout
			vim.g.keyboard_layout = layout
			print("layout set to " .. layout .. "; reload for harpoon indicators to update")
		end
	else
		print("layout not supported!")
	end
end, {
	nargs = 1,
	complete = function()
		local accepted_layouts = { "azerty", "qwerty" }
		return accepted_layouts
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.hl", "hypr*.conf" },
	callback = function()
		vim.bo.filetype = "hyprlang"
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.ejs" },
	callback = function()
		vim.bo.filetype = "html"
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup("highlight-yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_user_command("Registers", function()
	require("lz.n").trigger_load("telescope.nvim")
	require("telescope.builtin").registers({
		layout_strategy = "vertical",
		layout_config = {
			width = 0.8,
			height = 0.7,
		},
	})
end, {})
-- Set relative line numbers color explicitly
--[[ vim.api.nvim_set_hl(0, "LineNr", { fg = "#938aad", bg = "NONE" }) -- muted purple-grey
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ebde76", bg = "NONE", bold = true }) -- yellow for the current line ]]
