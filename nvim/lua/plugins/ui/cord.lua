require("lz.n").load({
	{
		"cord.nvim",
		lazy = true,
		after = function()
			require("cord").setup()
		end,
	},
})
