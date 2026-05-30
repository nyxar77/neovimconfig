require("lz.n").load({
	{
		"oil.nvim",
		lazy = false,
		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "open oil",
			},
			{
				"+",
				function()
					require("oil").close()
				end,
				desc = "close oil",
			},
		},
		after = function()
			require("oil").setup({
				delete_to_trash = true,
				keymaps = {
					["<C-c>"] = { "actions.close", mode = "n" },
					["<Esc>"] = { "actions.close", mode = "n", desc = "mapping to <C-c>" },
				},
			})
		end,
	},
})
