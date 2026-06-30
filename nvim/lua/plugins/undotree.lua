require("lz.n").load({
	{
		"undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undotree" },
		},
	},
})
