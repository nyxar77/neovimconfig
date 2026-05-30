require("lz.n").load({
	{
		"which-key.nvim",
		event = "VimEnter",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		after = function()
			require("which-key").setup({
				win = {
					no_overlap = true,
					padding = { 1, 2 },
					title = true,
					title_pos = "center",
					zindex = 1000,
					bo = {},
					wo = {},
					border = "rounded",
				},
				layout = {
					width = { min = 20, max = 40 },
					height = { min = 4, max = 10 },
					spacing = 2,
				},
			})
		end,
	},
})
