local undotree_open = false

require("lz.n").load({
	{
		"undotree",
		cmd = {
			"UndotreeShow",
			"UndotreeHide",
		},
		keys = {
			{
				"<leader>u",
				function()
					if undotree_open then
						vim.cmd("UndotreeHide")
						undotree_open = false
					else
						vim.cmd("UndotreeShow")
						undotree_open = true
					end
				end,
				desc = "Toggle undotree",
			},
		},
	},
})
