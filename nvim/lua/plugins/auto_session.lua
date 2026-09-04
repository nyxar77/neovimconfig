require("lz.n").load({
	{
		"auto-session",
		lazy = false,
		after = function()
			require("auto-session").setup({
				suppressed_dirs = { "~/", "/", "/tmp" },
				session_lens = {
					picker = "snacks",
				},
			})

			vim.keymap.set("n", "<leader>os", "<cmd>AutoSession search<CR>", {
				desc = "search sessions",
			})
			vim.keymap.set("n", "<leader>oa", "<cmd>AutoSession toggle<CR>", {
				desc = "toggle session autosave",
			})
		end,
	},
})
