require("lz.n").load({
	{
		"url-open",
		cmd = "URLOpenUnderCursor",
		keys = {
			{ "gx", "<esc>:URLOpenUnderCursor<cr>" },
		},
		after = function()
			require("url-open").setup({
				open_only_when_cursor_on_url = true,
				highlight_url = {
					all_urls = {
						enabled = true,
						fg = "#B0E0E6",
					},
					cursor_move = {
						enabled = true,
						fg = "#A3CFFF",
						bg = nil,
						underline = true,
					},
				},
			})
		end,
	},
})
