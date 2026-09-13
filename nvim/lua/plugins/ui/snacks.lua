require("lz.n").load({
	{
		"snacks.nvim",
		lazy = false,
		priority = 500,
		after = function()
			local function telescope_action(method, opts)
				return function()
					require("lz.n").trigger_load("telescope.nvim")
					require("telescope.builtin")[method](opts)
				end
			end

			-- Replace the O with a six-row Nix snowflake so the whole header has
			-- one fixed height and never needs a responsive layout mode.
			local nix_mark = {
				{
					{ "   " },
					{ "██", hl = "DashboardNixPurple" },
					{ " " },
					{ "▄█▄▄█", hl = "DashboardNixCyan" },
					{ "   " },
				},
				{
					{ " " },
					{ "▄██", hl = "DashboardNixPurple" },
					{ "██", hl = "DashboardNixPurpleInner" },
					{ "████", hl = "DashboardNixCyanInner" },
					{ "▀▄▄", hl = "DashboardNixCyan" },
					{ " " },
				},
				{
					{ "▄▄▄", hl = "DashboardNixCyan" },
					{ "██▀", hl = "DashboardNixCyanInner" },
					{ "  " },
					{ "▀██", hl = "DashboardNixPurpleInner" },
					{ "██▄", hl = "DashboardNixPurple" },
				},
				{
					{ "▀██", hl = "DashboardNixCyan" },
					{ "██▄", hl = "DashboardNixCyanInner" },
					{ "  " },
					{ "▄██", hl = "DashboardNixPurpleInner" },
					{ "▀▀▀", hl = "DashboardNixPurple" },
				},
				{
					{ " " },
					{ "▀▀▄", hl = "DashboardNixPurple" },
					{ "██", hl = "DashboardNixPurpleInner" },
					{ "████", hl = "DashboardNixCyanInner" },
					{ "██▀", hl = "DashboardNixCyan" },
					{ " " },
				},
				{
					{ "   " },
					{ "██▀", hl = "DashboardNixPurple" },
					{ "█", hl = "DashboardNixPurpleInner" },
					{ "█", hl = "DashboardNixCyanInner" },
					{ " " },
					{ "▀█", hl = "DashboardNixCyan" },
					{ "   " },
				},
			}
			local neovim_wordmark = {
				{
					"███╗   ██╗███████╗",
					"██╗   ██╗██╗███╗   ███╗",
				},
				{
					"████╗  ██║██╔════╝",
					"██║   ██║██║████╗ ████║",
				},
				{
					"██╔██╗ ██║█████╗  ",
					"██║   ██║██║██╔████╔██║",
				},
				{
					"██║╚██╗██║██╔══╝  ",
					"╚██╗ ██╔╝██║██║╚██╔╝██║",
				},
				{
					"██║ ╚████║███████╗",
					" ╚████╔╝ ██║██║ ╚═╝ ██║",
				},
				{
					"╚═╝  ╚═══╝╚══════╝",
					"  ╚═══╝  ╚═╝╚═╝     ╚═╝",
				},
			}

			local function dashboard_header()
				local ne_width = 0
				local vim_width = 0
				for _, wordmark in ipairs(neovim_wordmark) do
					ne_width = math.max(ne_width, vim.api.nvim_strwidth(wordmark[1]))
					vim_width = math.max(vim_width, vim.api.nvim_strwidth(wordmark[2]))
				end

				local text = {}
				for index, wordmark in ipairs(neovim_wordmark) do
					local ne_padding = ne_width - vim.api.nvim_strwidth(wordmark[1])
					local vim_padding = vim_width - vim.api.nvim_strwidth(wordmark[2])
					text[#text + 1] = { wordmark[1] .. (" "):rep(ne_padding + 1), hl = "DashboardWordmarkLeft" }
					for _, part in ipairs(nix_mark[index]) do
						text[#text + 1] = part
					end
					text[#text + 1] = { " " .. wordmark[2] .. (" "):rep(vim_padding), hl = "DashboardWordmarkRight" }
					if index < #neovim_wordmark then
						text[#text + 1] = { "\n" }
					end
				end

				return { align = "center", text = text, padding = 2 }
			end

			local startup_snapshot

			require("snacks").setup({
				bigfile = { enabled = true },
				dashboard = {
					enabled = true,
					sections = {
						dashboard_header,
						{ section = "keys", gap = 1, padding = 1 },
						function()
							if not startup_snapshot then
								local stats = require("core.lz_stats")
								startup_snapshot = {
									loaded = stats.loaded,
									total = stats.total,
									elapsed_ms = (vim.uv.hrtime() - vim.g.nyxar_config_start_time) / 1e6,
								}
							end

							return {
								align = "center",
								text = {
									{ "⚡ Neovim loaded ", hl = "footer" },
									{
										("%d/%d"):format(startup_snapshot.loaded, startup_snapshot.total),
										hl = "special",
									},
									{ " plugins in ", hl = "footer" },
									{ ("%.2fms"):format(startup_snapshot.elapsed_ms), hl = "special" },
								},
							}
						end,
					},
					preset = {
						keys = {
							{
								icon = " ",
								key = "f",
								desc = "Find File",
								action = telescope_action("find_files"),
							},
							{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
							{
								icon = " ",
								key = "g",
								desc = "Find Text",
								action = telescope_action("live_grep", {
									vimgrep_arguments = {
										"rg",
										"--color=never",
										"--no-heading",
										"--with-filename",
										"--line-number",
										"--column",
										"--smart-case",
										"--trim",
									},
								}),
							},
							{
								icon = " ",
								key = "r",
								desc = "Recent Files",
								action = telescope_action("oldfiles"),
							},
							{
								icon = " ",
								key = "c",
								desc = "Config",
								action = telescope_action("find_files", { cwd = vim.fn.stdpath("config") }),
							},
							{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
						},
					},
				},
				explorer = { enabled = false },
				indent = { enabled = false },
				input = { enabled = true },
				picker = { enabled = true },
				notifier = { enabled = true, timeout = 6500 },
				quickfile = { enabled = true },
				scope = { enabled = true },
				scroll = { enabled = false },
				statuscolumn = { enabled = true },
				words = { enabled = true },
			})
		end,
	},
})
