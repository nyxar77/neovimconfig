return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		if vim.g.keyboardLayout == "azerty" then
			Indicators = { "a", "z", "e", "s" }
			Active_indicators = { "A", "Z", "E", "S" }
		else
			Indicators = { "q", "w", "e", "s" }
			Active_indicators = { "Q", "W", "E", "S" }
		end
		local function dap_status()
			local ok, dap = pcall(require, "dap")
			if ok and dap.session() then
				return "  debug"
			end
			return ""
		end

		require("lualine").setup({
			icons_enabled = true,
			options = {
				theme = vim.g.hardhacker_lualine_theme,
				-- theme = vim.g.lualine_theme,
				-- theme = "catppuccin-machitto",
				section_separators = { left = "", right = "" },
				component_separators = "",
			},
			disabled_filetypes = {
				statusline = { "oil" },
				tabline = { "oil" },
				winbar = { "oil" },
			},
			tabline = {
				lualine_a = {
					function()
						if vim.bo.filetype == "toggleterm" then
							return "terminal [" .. vim.b.toggle_number .. "]"
						else
							return "%f %r"
						end
					end,
				},
				lualine_b = {
					{
						"harpoon2",
						icon = " ",
						color_active = { fg = "#fc770a" },
						_seperator = "d",
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
						separator = " ",
					},
				},
				lualine_z = { "tabs" },
			},
			sections = {
				lualine_a = { { icon = "", "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { "filename", "branch" },
				lualine_c = {
					"%=", --[[ add your center components here in place of this comment ]]
				},
				lualine_x = { "diff", "diagnostics" },
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			--[[ inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			}, ]]
			extensions = {},
		})
	end,
}
