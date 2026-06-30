local function undotree_is_visible()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "undotree" then
			return true
		end
	end

	return false
end

local function undotree_toggle()
	if undotree_is_visible() then
		vim.cmd.UndotreeHide()
	else
		vim.cmd.UndotreeShow()
	end
end

require("lz.n").load({
	{
		"undotree",
		cmd = { "UndotreeShow", "UndotreeHide" },
	},
})

vim.keymap.set("n", "<leader>u", undotree_toggle, { desc = "Toggle undotree" })
