require("lz.n").load({
	{
		"toggleterm.nvim",
		keys = { "<M-,>", "<leader>t" },
		after = function()
			require("toggleterm").setup({
				open_mapping = [[<M-,>]],
				persist_mode = true,
				auto_scroll = true,
				direction = "float",
				float_opts = {
					border = "curved",
				},
				highlights = {
					FloatBorder = {
						guifg = "#E965A5",
					},
				},
			})
			vim.keymap.set("n", "<leader>t", "<cmd>TermSelect<cr>", {
				desc = "select terminal",
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "²", [[<C-\><C-n>]], opts)
			end

			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},
})
