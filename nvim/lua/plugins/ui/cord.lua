require("lz.n").load({
	{
		"cord.nvim",
		event = "BufReadPost",
		after = function()
			require("cord").setup()
		end,
	},
})
