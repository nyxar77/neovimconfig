return {
	{
		"hardhackerlabs/theme-vim",
		priority = 999,
		event = "VeryLazy",
		lazy = false,
		config = function()
			-- Define a theme table
			local fallbackTheme = "catppuccin"
			local preferredTheme = "hardhacker-darker"

			--[[ local fallbackTheme = "hardhacker-darker"
			local preferredTheme = "catppuccin" ]]
			local themes = {
				["hardhacker-darker"] = {
					lualine_theme = vim.g.hardhacker_lualine_theme,
					hardhacker_hide_tilde = 1,
					hardhacker_keyword_italic = 1,
				},
				["catppuccin"] = {
					lualine_theme = "catppuccin",
				},
				["dracula"] = {
					lualine_theme = "dracula-nvim",
				},
				["gruvbox"] = {
					lualine_theme = "gruvbox",
				},
			}

			-- Function to set colorscheme
			local function setTheme(theme)
				local ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
				if ok then
					local cfg = themes[theme]
					if cfg then
						for k, v in pairs(cfg) do
							vim.g[k] = v
						end
					end
				end
				return ok
			end

			-- Example usage: pick the first theme that works
			if not setTheme(preferredTheme) then
				setTheme(fallbackTheme)
			end
		end,
	},
	{
		"alexmozaidze/palenight.nvim",
	},
	{
		"olimorris/onedarkpro.nvim",
		config = function()
			require("onedarkpro").setup({
				options = {
					cursorline = false, -- Use cursorline highlighting?
					transparency = true, -- Use a transparent background?
					terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
					lualine_transparency = true, -- Center bar transparency?
					highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
				},
			})
		end,
	},
	{
		"Mofiqul/dracula.nvim",
		config = function()
			require("dracula").setup({
				transparent_bg = true,
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				transparent_mode = true,
				overrides = {
					Pmenu = { link = "Normal" },
				},
				italic = {
					strings = true, -- Make string literals italic
					emphasis = true, -- Make emphasized text italic
					comments = true, -- Make comments italic
					operators = false, -- Make operators italic
					folds = true, -- Make fold indicators italic
				},
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		opts = {
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				mini = true,
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				snacks = true,
				telescope = true,
				treesitter_context = true,
				which_key = true,
			},
		},
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				dim_inactive = {
					enabled = true,
				},
				background = {
					light = "latte",
					dark = "mocha",
				},
				float = {
					transparent = true,
					solid = true,
				},
				auto_integrations = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					notify = false,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
				},
			})
		end,
	},
}
