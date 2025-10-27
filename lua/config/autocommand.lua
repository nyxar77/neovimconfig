local changeLayout = require("config.changeLayout")

local function augroup(name)
	return vim.api.nvim_create_augroup("nyxar_" .. name, { clear = true })
end

-- setting the cheatsheet command
vim.api.nvim_create_user_command("Cheatsheet", function()
	-- vim.cmd('e ~/.config/nvim/doc/cheatsheet.md')
	vim.schedule(function()
		vim.bo.modifiable = false
		vim.bo.readonly = true
	end)
end, {})

-- set keyboard layout
vim.api.nvim_create_user_command("SetLayout", function(opts)
	local keyboardLayout = opts.args
	if changeLayout.acceptedLayout(keyboardLayout) then
		if changeLayout.savelayout(keyboardLayout) == true then
			print("reload for changes to take affect!")
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
	require("telescope.builtin").registers({
		layout_strategy = "vertical",
		layout_config = {
			width = 0.8,
			height = 0.7,
		},
	})
end, {})
