local options = {
	-- Cursor shape "wide"
	-- guicursor = "",

	-- Line numbers
	nu = true,
	rnu = true,
	-- tabs
	tabstop = 4,
	softtabstop = 4,
	shiftwidth = 4,
	expandtab = true,

	smartindent = true,
	wrap = false,

	clipboard = "unnamed,unnamedplus",

	-- backups
	swapfile = false,
	backup = false,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
	undofile = true,

	-- search operations
	hlsearch = false,
	incsearch = true,
	-- gui colors
	guifont = "Fira Code",
	termguicolors = true,
	scrolloff = 8,
	signcolumn = "yes",
	updatetime = 50,
	--colorcolumn = "0",_
	mouse = "", -- disable mouse
}

vim.g.mapleader = " "
for k, v in pairs(options) do
	vim.opt[k] = v
end

