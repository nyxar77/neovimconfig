require("lz.n").load({
	{
		"catppuccin",
		priority = 999,
		event = "BufReadPre",
		before = function()
			local hardhacker = {
				fg = "#e4dee9",
				selection = "#3f3951",
				comment = "#938aad",
				red = "#e965a5",
				green = "#b1f2a7",
				yellow = "#ebde76",
				blue = "#b1baf4",
				purple = "#e192ef",
				pink = "#ff85c0",
				cyan = "#b3f4f3",
				orange = "#fab387",
				teal = "#94e2d5",
				border = "#575268",
			}

			require("catppuccin").setup({
				flavour = "mocha",
				background = { light = "latte", dark = "mocha" },
				transparent_background = true,
				show_end_of_buffer = false,
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
						red = hardhacker.pin,
						green = hardhacker.green,
						yellow = hardhacker.yellow,
						blue = hardhacker.blue,
						magenta = hardhacker.purple,
						pink = hardhacker.pink,
						teal = hardhacker.teal,
						sky = hardhacker.cyan,
						lavender = hardhacker.blue,
						peach = hardhacker.yellow,
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
					snacks = { enabled = true, indent_scope_color = "magenta" },
				},
			})
		end,
		after = function()
			local themes = {
				["catppuccin"] = { lualine_theme = "catppuccin" },
				["gruvbox"] = { lualine_theme = "gruvbox" },
				["hardhacker-darker"] = {
					lualine_theme = vim.g.hardhacker_lualine_theme,
					hardhacker_hide_tilde = 1,
					hardhacker_keyword_italic = 1,
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

			if not setTheme("catppuccin") then
				setTheme("hardhacker-darker")
			end
		end,
	},
	--[[ {
		"reactive.nvim",
		load_after = { "catppuccin" },
		after = function()
			require("reactive").setup({
				load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
			})
		end,
	}, ]]
})
--[[ {
		"olimorris/onedarkpro.nvim",
		config = function()
			require("onedarkpro").setup({
				options = {
					cursorline = true, -- Use cursorline highlighting?
					transparency = true, -- Use a transparent background?
					terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
					lualine_transparency = true, -- Center bar transparency?
					highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
				},
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
	}, ]]
