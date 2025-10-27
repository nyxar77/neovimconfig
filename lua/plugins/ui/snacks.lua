return {
	"folke/snacks.nvim",
	event = "VeryLazy",
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{
						icon = " ",
						key = "f",
						desc = "Find File",
						action = ":lua require('telescope.builtin').find_files()",
					},
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ':lua require("telescope.builtin").live_grep({ vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--trim" } })',
					},

					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua require('telescope.builtin').oldfiles()",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')})",
					},
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
		},
		explorer = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true, timeout = 6500 },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	--[[ config = function()
        require "snacks".setup {
            header = {
                "                                   ",
                "          ▀████▀▄▄              ▄█ ",
                "            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
                "    ▄        █          ▀▀▀▀▄  ▄▀  ",
                "   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
                "  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
                "  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
                "   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
                "    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
                "   █   █  █      ▄▄           ▄▀   ",
            },
        }
    end ]]
}
