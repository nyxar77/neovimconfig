require("lz.n").load({
	{
		"ccc.nvim",
		event = "BufReadPost",
		after = function()
			require("ccc").setup({
				highlighter = {
					auto_enable = true,
				},
			})
		end,
	},
})
