local colorscheme = "hardhacker";
local statusOk, _ = pcall(vim.cmd, "colorscheme ".. colorscheme);
if not statusOk then
    local statusOk, _ = pcall(vim.cmd, "colorscheme gruvbox");
    if not statusOk then
        vim.notify("colorscheme ".. colorscheme.. " Not Found!");
    end
	return
end

vim.opt.guifont='Fira Code'


