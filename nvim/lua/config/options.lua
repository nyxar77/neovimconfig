local variant = io.popen("localectl status | grep -i 'X11 Variant'"):read("*l")

if variant then
	local selectedLayout
	local tableLayouts = { "azerty", "qwerty" }
	for _, value in ipairs(tableLayouts) do
		local result = variant:lower():find(value)
		if result then
			selectedLayout = value
			break
		end
	end
	vim.api.nvim_set_var("keyboard_layout", selectedLayout or "azerty")
end

vim.g.mapleader = " "
local options = {
	-- Cursor shape "wide"
	-- guicursor = "",

	-- Line numbers
	nu = true,
	rnu = true,
	-- tabs
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,

	smartindent = true,
	wrap = false,

	clipboard = "",

	-- backups
	swapfile = false,
	backup = false,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
	undofile = true,

	--theme
	-- search operations
	hlsearch = true,
	incsearch = true,
	-- gui colors
	guifont = "Fira Code",
	termguicolors = true,
	scrolloff = 8,
	signcolumn = "yes",
	updatetime = 50,
	--colorcolumn = "0",_
	mouse = "n", -- enable for normal mode only
	foldcolumn = "1",
	foldlevel = 99,
	foldlevelstart = 99,
	foldenable = true,
	winborder = "rounded",
}

-- vim.g.keyboardLayout = changeLayout.loadlayout();
vim.g.keyboardLayout = vim.g.keyboard_layout
vim.o.background = "dark"

for k, v in pairs(options) do
	vim.opt[k] = v
end
