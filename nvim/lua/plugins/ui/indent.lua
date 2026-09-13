require("lz.n").load({
	{
		"indent-blankline.nvim",
		event = "BufReadPost",
		after = function()
			local colors = require("catppuccin.palettes").get_palette("mocha")
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local highlight_colors = {
				RainbowRed = colors.red,
				RainbowYellow = colors.yellow,
				RainbowBlue = colors.blue,
				RainbowOrange = colors.peach,
				RainbowGreen = colors.green,
				RainbowViolet = colors.mauve,
				RainbowCyan = colors.teal,
			}

			for group, color in pairs(highlight_colors) do
				vim.api.nvim_set_hl(0, group, { fg = color })
			end

			require("ibl").setup({ indent = { highlight = highlight } })

			local command_file = vim.api.nvim_get_runtime_file("after/plugin/commands.lua", false)[1]
			if command_file then
				dofile(command_file)
			end
		end,
	},
})
