require("lz.n").load({
	{
		"vimtex",
		ft = { "tex", "latex" },
		before = function()
			-- vim.g.vimtex_view_method = "zathura"
			-- vim.g.vimtex_view_general_viewer = "okular"
		end,
	},
})
