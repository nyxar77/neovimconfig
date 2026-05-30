require("lz.n").load({
	{
		"nvim-lint",
		event = "BufWritePost",
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
