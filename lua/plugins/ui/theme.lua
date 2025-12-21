return {
	{
		"hardhackerlabs/theme-vim",
		priority = 999,
		event = "VeryLazy",
		lazy = false,
		config = function()
			local fallbackTheme = "hardhacker-darker"
			local preferredTheme = "catppuccin"

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
				flavour = "mocha",
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
		},
		config = function()
			-- require("catppuccin").setup({
			-- 	flavour = "mocha",
			-- 	compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
			-- 	transparent_background = true,
			-- 	term_colors = true,
			-- 	styles = {
			-- 		comments = { "italic" },
			-- 		functions = { "bold" },
			-- 		keywords = { "italic" },
			-- 		operators = { "bold" },
			-- 		conditionals = { "bold" },
			-- 		loops = { "bold" },
			-- 		booleans = { "bold", "italic" },
			-- 		numbers = {},
			-- 		types = {},
			-- 		strings = {},
			-- 		variables = {},
			-- 		properties = {},
			-- 	},
			-- })

			-- Define the Hardhacker Palette explicitly for reuse
			local hardhacker = {
				fg = "#e4dee9",
				selection = "#3f3951",
				comment = "#938aad", -- Muted purple-grey for comments

				-- The Neon Accents
				red = "#e965a5", -- Functions / Errors
				green = "#b1f2a7", -- Strings
				yellow = "#ebde76", -- Parameters / Warnings
				blue = "#b1baf4", -- Keywords
				purple = "#e192ef", -- Constants / Builtins
				pink = "#ff85c0",
				cyan = "#b3f4f3", -- Types / Classes
				orange = "#fab387", -- *NEW* Numbers / Booleans (Breaks up the red)
				teal = "#94e2d5", -- *NEW* Operators / Delimiters

				border = "#575268", -- Muted border (so it doesn't scream at you)
			}
			require("catppuccin").setup({
				flavour = "mocha",
				background = { light = "latte", dark = "mocha" },
				transparent_background = true, -- Keep false for that deep void background
				show_end_of_buffer = false, -- Hide the tildes (~) at end of buffer
				term_colors = true,
				auto_integrations = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.01,
				},
				no_italic = false,
				no_bold = false,
				no_underline = false,
				float = {
					transparent = true,
					solid = true,
				},
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = { "bold" },
					keywords = { "italic" },
					strings = {},
					variables = {},
					numbers = {},
					booleans = { "bold" },
					properties = {},
					types = { "bold" },
					operators = {},
				},

				color_overrides = {
					mocha = {
						text = hardhacker.fg,
						subtext1 = hardhacker.comment,
						subtext0 = "#7a6f8f",

						surface2 = hardhacker.selection,
						surface1 = "#2b263b",
						surface0 = "#1b182c",

						-- Redistributing colors to avoid "Red Overload"
						red = hardhacker.pin,
						green = hardhacker.green,
						yellow = hardhacker.yellow,
						blue = hardhacker.blue,
						magenta = hardhacker.purple,
						pink = hardhacker.pink,
						teal = hardhacker.teal,
						sky = hardhacker.cyan,
						lavender = hardhacker.blue,
						peach = hardhacker.yellow, -- Peach mapped to Orange
						maroon = hardhacker.red,
						rosewater = hardhacker.yellow,
						flamingo = hardhacker.red,
					},
				},
				integrations = {
					cmp = true,
					dap = true,
					dap_ui = true,
					diffview = true,
					dropbar = { enabled = true, color_mode = true },
					fidget = true,
					flash = true,
					fzf = true,
					gitsigns = true,
					grug_far = true,
					hop = true,
					indent_blankline = { enabled = true, colored_indent_levels = true },
					lsp_saga = true,
					lsp_trouble = true,
					markdown = true,
					mason = true,
					mini = { enabled = true },
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
					notify = true,
					nvimtree = true,
					rainbow_delimiters = true,
					render_markdown = true,
					semantic_tokens = true,
					telescope = { enabled = true, style = "nvchad" },
					treesitter = true,
					treesitter_context = true,
					which_key = true,
					snacks = {
						enabled = true,
						indent_scope_color = "magenta",
					},
				},
			})
		end,
	},
}
