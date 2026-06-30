local changeLayout = require("config.changeLayout")

local function command_output(command)
	local handle = io.popen(command .. " 2>/dev/null")
	local output = handle and handle:read("*a") or ""
	if handle then
		handle:close()
	end
	return output
end

local function layout_from_keymap(value)
	local normalized = value:lower()
	if normalized:find("azerty", 1, true) or normalized:find("french", 1, true) or normalized:find("belgian", 1, true) then
		return "azerty"
	end

	if normalized:find("qwerty", 1, true) or normalized:find("english", 1, true) or normalized:match("%f[%a]us%f[%A]") then
		return "qwerty"
	end

	return nil
end

local function detect_hyprland_layout()
	if not os.getenv("HYPRLAND_INSTANCE_SIGNATURE") then
		return nil
	end

	local devices = command_output("hyprctl devices")
	for line in devices:gmatch("[^\r\n]+") do
		local active_keymap = line:match("^%s*active keymap:%s*(.+)$")
		if active_keymap then
			local layout = layout_from_keymap(active_keymap)
			if layout then
				return layout
			end
		end
	end

	local kb_layout = command_output("hyprctl getoption input:kb_layout")
	local layout = layout_from_keymap(kb_layout)
	if layout then
		return layout
	end

	return "azerty"
end

local function detect_localectl_layout()
	local output = command_output("localectl status")
	local normalized = output:lower()
	local x11_variant = normalized:match("x11 variant:%s*([^\n]+)")
	local layout = x11_variant and layout_from_keymap(x11_variant)
	if layout then
		return layout
	end

	local x11_layout = normalized:match("x11 layout:%s*([^\n]+)")
	if x11_layout then
		if x11_layout:match("%f[%a]fr%f[%A]") or x11_layout:match("%f[%a]be%f[%A]") then
			return "azerty"
		end
		if x11_layout:match("%f[%a]us%f[%A]") or x11_layout:match("%f[%a]gb%f[%A]") then
			return "qwerty"
		end
	end

	return nil
end

local function detect_keyboard_layout()
	local saved_layout = changeLayout.loadlayout()
	if changeLayout.acceptedLayout(saved_layout) then
		return saved_layout
	end

	return detect_hyprland_layout() or detect_localectl_layout() or "azerty"
end

vim.g.keyboardLayout = detect_keyboard_layout()
vim.g.keyboard_layout = vim.g.keyboardLayout

vim.g.mapleader = " "
local undo_dir = vim.fn.expand("~/.vim/undodir")
vim.fn.mkdir(undo_dir, "p")

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
	undodir = undo_dir,
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

vim.o.background = "dark"

for k, v in pairs(options) do
	vim.opt[k] = v
end
