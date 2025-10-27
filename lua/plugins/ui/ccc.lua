return {
	"uga-rosa/ccc.nvim",
	event = "BufReadPost",
	Lazy = true,
	config = function()
		local ccc = require("ccc")
		ccc.setup({
			highlighter = {
				auto_enable = true,
			},
		})
	end,
}
