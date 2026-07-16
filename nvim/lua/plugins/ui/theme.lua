require("lz.n").load({
	{
		"catppuccin-nvim",
		lazy = false,
		priority = 100,
		before = function()
			-- HardHacker's terminal colors, expanded into a complete Catppuccin palette.
			-- The ANSI colors below stay exact; the extra shades only fill editor UI roles.
			local hardhacker = {
				rosewater = "#f2e8f0",
				flamingo = "#f0a6c9",
				pink = "#ff85c0",
				mauve = "#e192ef",
				red = "#e965a5",
				maroon = "#cf5d91",
				peach = "#ebde76",
				yellow = "#ebde76",
				green = "#b1f2a7",
				teal = "#9ce7d2",
				sky = "#b3f4f3",
				sapphire = "#8ed8ec",
				blue = "#b1baf4",
				lavender = "#cbc8ff",

				text = "#e4dee9",
				subtext1 = "#c9c1d4",
				subtext0 = "#afa6bd",
				overlay2 = "#938aad",
				overlay1 = "#7f768f",
				overlay0 = "#6b6379",
				surface2 = "#575268",
				surface1 = "#3f3951",
				surface0 = "#342f42",
				base = "#282433",
				mantle = "#211e2a",
				crust = "#191720",
			}

			---@diagnostic disable-next-line: param-type-mismatch
			require("catppuccin").setup({
				flavour = "mocha",
				background = { light = "latte", dark = "mocha" },
				transparent_background = true,
				float = {
					transparent = true,
					solid = true,
				},

				-- Catppuccin maps ANSI black to an editor overlay color. We apply the
				-- real terminal palette after loading instead, so :terminal matches Kitty.
				term_colors = false,
				dim_inactive = { enabled = false },
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
					miscs = {},
				},
				lsp_styles = {
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
					inlay_hints = { background = false },
				},
				---@diagnostic disable-next-line: missing-fields
				color_overrides = {
					mocha = hardhacker,
				},
				highlight_overrides = {
					mocha = function(colors)
						return {
							Cursor = { fg = colors.mantle, bg = colors.red },
							TermCursor = { fg = colors.mantle, bg = colors.red },
							LineNr = { fg = colors.overlay2 },
							CursorLineNr = { fg = colors.yellow, style = { "bold" } },
							EndOfBuffer = { fg = colors.surface0 },
							FloatBorder = { fg = colors.surface2 },
							FloatTitle = { fg = colors.mantle, bg = colors.pink, style = { "bold" } },
							WinSeparator = { fg = colors.surface1 },
							WinBar = { fg = colors.lavender, style = { "bold" } },
							Pmenu = { fg = colors.subtext1 },
							PmenuSel = { fg = colors.text, bg = colors.surface1, style = { "bold" } },
							PmenuMatch = { fg = colors.yellow, style = { "bold" } },

							-- Keep the syntax varied; red is a signature accent rather than the base language.
							Identifier = { fg = colors.text },
							Function = { fg = colors.blue, style = { "bold" } },
							Statement = { fg = colors.mauve },
							Keyword = { fg = colors.mauve, style = { "italic" } },
							Conditional = { fg = colors.mauve, style = { "italic" } },
							Repeat = { fg = colors.mauve },
							Exception = { fg = colors.red, style = { "italic" } },
							Include = { fg = colors.pink, style = { "italic" } },
							Operator = { fg = colors.text },
							Constant = { fg = colors.yellow },
							Number = { fg = colors.yellow },
							Boolean = { fg = colors.yellow, style = { "bold" } },
							Type = { fg = colors.sky, style = { "bold" } },
							Structure = { fg = colors.sky, style = { "bold" } },

							["@variable.builtin"] = { fg = colors.subtext1, style = { "italic" } },
							["@variable.parameter"] = { fg = colors.subtext1 },
							["@function.builtin"] = { fg = colors.yellow, style = { "bold" } },
							["@function.method"] = { fg = colors.red, style = { "bold" } },
							["@function.method.call"] = { fg = colors.red, style = { "bold" } },
							["@function.macro"] = { fg = colors.pink, style = { "bold" } },
							["@keyword.function"] = { fg = colors.mauve, style = { "italic" } },
							["@keyword.operator"] = { fg = colors.mauve, style = { "italic" } },
							["@keyword.return"] = { fg = colors.pink, style = { "italic" } },
							["@keyword.exception"] = { fg = colors.red, style = { "italic" } },
							["@constant.builtin"] = { fg = colors.yellow, style = { "bold" } },
							["@type.builtin"] = { fg = colors.sky, style = { "bold" } },
							["@constructor"] = { fg = colors.yellow },
						}
					end,
				},

				-- Auto-detection only supports a few package managers, not this Nix/lz.n setup.
				default_integrations = false,
				auto_integrations = false,
				integrations = {
					cmp = true,
					dap = true,
					dap_ui = true,
					gitsigns = true,
					indent_blankline = {
						enabled = true,
						scope_color = "mauve",
						colored_indent_levels = false,
					},
					markview = true,
					snacks = { enabled = true, indent_scope_color = "mauve" },
					telescope = { enabled = true, style = "nvchad" },
					ufo = true,
					which_key = true,
				},
			})
		end,
		after = function()
			vim.cmd.colorscheme("catppuccin")

			local terminal = {
				"#282433",
				"#e965a5",
				"#b1f2a7",
				"#ebde76",
				"#b1baf4",
				"#e192ef",
				"#b3f4f3",
				"#eee9fc",
				"#938aad",
				"#e965a5",
				"#b1f2a7",
				"#ebde76",
				"#b1baf4",
				"#e192ef",
				"#b3f4f3",
				"#eee9fc",
			}

			for index, color in ipairs(terminal) do
				vim.g["terminal_color_" .. (index - 1)] = color
			end
		end,
	},
	{
		"reactive.nvim",
		event = "VimEnter",
		after = function()
			local colors = require("catppuccin.palettes").get_palette("mocha")
			local color_utils = require("catppuccin.utils.colors")

			local function mode_color(color, tint_strength, line_number_color)
				local row = color_utils.blend(color, colors.base, tint_strength)
				return {
					hl = {
						ReactiveCursor = { fg = colors.base, bg = color },
					},
					winhl = {
						CursorLine = { bg = row },
						CursorLineNr = {
							fg = line_number_color or color,
							bg = row,
							bold = true,
						},
					},
				}
			end

			local normal = mode_color(colors.blue, 0.13, colors.yellow)
			local insert = mode_color(colors.green, 0.14)
			local command = mode_color(colors.yellow, 0.15)
			local replace = mode_color(colors.red, 0.16)
			local visual = mode_color(colors.mauve, 0.16)
			local select = mode_color(colors.pink, 0.16)
			local terminal = mode_color(colors.green, 0.14)

			visual.winhl.Visual = { bg = color_utils.blend(colors.mauve, colors.base, 0.32) }
			select.winhl.Visual = { bg = color_utils.blend(colors.pink, colors.base, 0.32) }

			require("reactive").add_preset({
				name = "hardhacker-modes",
				init = function()
					vim.opt.guicursor:append("a:ReactiveCursor")
					vim.opt.cursorline = true
				end,
				static = {
					winhl = {
						inactive = {
							CursorLine = { bg = colors.mantle },
							CursorLineNr = { fg = colors.overlay2, bg = colors.mantle, bold = true },
						},
					},
				},
				modes = {
					n = normal,
					[{ "i", "niI" }] = insert,
					c = command,
					[{ "R", "niR", "niV" }] = replace,
					[{ "v", "V", "\x16" }] = visual,
					[{ "s", "S", "\x13" }] = select,
					t = terminal,
					no = {
						operators = {
							[{ "gu", "gU", "g~", "~" }] = mode_color(colors.pink, 0.2),
							d = mode_color(colors.red, 0.22),
							y = mode_color(colors.yellow, 0.22),
							c = mode_color(colors.blue, 0.22),
						},
					},
				},
			})
		end,
	},
})
