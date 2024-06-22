require("Nyxar.remap");
require("Nyxar.lazy");
require("Nyxar.options");
-- require("Nyxar.lualsp");


-- set default color scheme:

--[[ local colorscheme = "gruvbox";
local statusOk, _ = pcall(vim.cmd, "colorscheme ".. colorscheme);
if not statusOk then
	vim.notify("colorscheme ".. colorscheme.. " Not Found!");
	return
end

--]] 
