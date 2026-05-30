require("lz.n").load({
	{
		"lint",
		event = { "BufWritePost", "BufReadPost" },
		after = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				nix = { "statix" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
})
