require("lz.n").load({
	{
		"auto-session",
		lazy = false,
		after = function()
			local launched_with_args = vim.fn.argc() > 0

			require("auto-session").setup({
				auto_restore = launched_with_args,
				auto_save = launched_with_args,
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
