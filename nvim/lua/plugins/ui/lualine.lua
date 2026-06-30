require("lz.n").load({
	{
		"lualine.nvim",
		event = "VimEnter",
		after = function()
			local indicators
			local active_indicators
			if vim.g.keyboardLayout == "azerty" then
				indicators = { "a", "z", "e", "s" }
				active_indicators = { "A", "Z", "E", "S" }
			else
				indicators = { "q", "w", "e", "s" }
				active_indicators = { "Q", "W", "E", "S" }
			end

			local function dap_status()
				local ok, dap = pcall(require, "dap")
				if ok and dap.session() then
					return " debug"
				end
				return ""
			end

			require("lualine").setup({
				icons_enabled = true,
				options = {
					theme = "auto",
					section_separators = { left = "", right = "" },
					component_separators = "",
					disabled_filetypes = {
						statusline = { "oil" },
						tabline = { "oil" },
						winbar = { "oil" },
					},
				},
				tabline = {
					lualine_a = {
						function()
							if vim.bo.filetype == "toggleterm" then
								return "terminal [" .. vim.b.toggle_number .. "]"
							elseif vim.bo.filetype == "TelescopePrompt" then
								return "[ PROMPT ]"
							else
								local filename = vim.fn.expand("%:t")
								local parent = vim.fn.expand("%:h:t")
								return parent .. "/" .. filename .. " %m %r"
							end
						end,
					},
					lualine_b = {
						{
							"harpoon2",
							icon = " ",
							indicators = indicators,
							active_indicators = active_indicators,
							color_active = { fg = "#fc770a" },
							_separator = " ",
							no_harpoon = "Harpoon not loaded",
						},
					},
					lualine_c = {},
					lualine_x = {
						dap_status,
						"lsp_status",
					},
					lualine_y = {
						{
							function()
								return vim.g.keyboardLayout or "?"
							end,
							color = { fg = "#fc770a" },
						},
					},
					lualine_z = { "tabs" },
				},
				sections = {
					lualine_a = { { icon = "", "mode", separator = { left = "" }, right_padding = 2 } },
					lualine_b = { "filename", "branch" },
					lualine_c = { "%=" },
					lualine_x = { "diff", "diagnostics" },
					lualine_y = { "filetype", "progress" },
					lualine_z = {
						{ "location", separator = { right = "" }, left_padding = 2 },
					},
				},
				extensions = {},
			})
		end,
	},
})
