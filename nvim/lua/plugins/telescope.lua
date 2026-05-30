require("lz.n").load({
	{
		"telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>ft", desc = "find files" },
			{ "<leader>fg", desc = "find git-tracked files in current dir" },
			{ "<leader>fl", desc = "Telescope Live grep" },
			{ "<leader>fd", desc = "Telescope diagnostics" },
			{ "<leader>fr", desc = "Telescope Live grep w args" },
		},
		after = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local lga_actions = require("telescope-live-grep-args.actions")

			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=always",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim",
					},
					file_ignore_patterns = {
						"^node_modules/",
						"^.direnv/",
						"^build/",
						"^.git/",
						"^dist/",
						"%.lock$",
						"%.exe$",
						"%.apk$",
						"%.tmp$",
						"%.swp$",
						"%.png$",
						"%.jpg$",
						"%.jpeg$",
					},
					layout_config = {
						preview_width = 0.6,
						width = 0.8,
						height = 0.8,
						preview_cutoff = 120,
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true,
						mappings = {
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
								["<C-space>"] = lga_actions.to_fuzzy_refine,
							},
						},
					},
				},
			})

			telescope.load_extension("live_grep_args")

			vim.keymap.set("n", "<leader>ft", builtin.find_files, { desc = "find files" })
			vim.keymap.set("n", "<leader>fg", function()
				local Cdir = vim.fn.expand("%:p")
				Cdir = string.gsub(Cdir, "oil://", "")
				Cdir = string.gsub(Cdir, "[^/]+%.%w+$", "")
				builtin.git_files({ cwd = Cdir })
			end, { desc = "find git-tracked files in current dir" })
			vim.keymap.set("n", "<leader>fl", function()
				builtin.live_grep({
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
				})
			end, { desc = "Telescope Live grep" })
			vim.keymap.set("n", "<leader>fd", function()
				builtin.diagnostics({
					layout_config = {
						preview_width = 0.5,
						width = 0.8,
						height = 0.8,
						preview_cutoff = 120,
					},
				})
			end, { desc = "Telescope diagnostics" })
			vim.keymap.set("n", "<leader>fr", function()
				telescope.extensions.live_grep_args.live_grep_args({
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
				})
			end, { desc = "Telescope grep w args" })
		end,
	},
})
