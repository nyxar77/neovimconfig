return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	lazy = true,
	config = function()
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

		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "²", [[<C-\><C-n>]], opts)
			vim.keymap.set("n", "<leader>t,", function()
				local ok, _ = pcall(vim.cmd.TermSelect())
				if ok then
					vim.notify("No terms is loaded yet", "info")
				end
			end, { noremap = true, desc = "term select" })
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		-- vim.cmd([[autocmd! TermOpen term://* lua set_terminal_keymaps()]])
	end,
}
