require("lz.n").load({
	{
		"cord.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("cord").setup()
		end,
	},
})
