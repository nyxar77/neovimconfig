require("lz.n").load({
	{
		"indent-blankline.nvim",
		event = "BufReadPost",
		after = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			require("ibl").setup({ indent = { highlight = highlight } })
		end,
	},
})
