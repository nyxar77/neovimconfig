local mappings = require("telescope.mappings")
local func = require("vim.func")
local layout = require("telescope.pickers.layout")
return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
	config = function()
		local telescope = require("telescope")

		local builtin = require("telescope.builtin")
		local lga_actions = require("telescope-live-grep-args.actions")
		telescope.setup({
			defaults = {
				--[[ mappings = {
        } ]]
				vimgrep_arguments = {
					"rg",
					"--color=always",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim", -- add this value
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
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					mappings = { -- extend mappings
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							-- freeze the current list and start a fuzzy search in the frozen list
							["<C-space>"] = lga_actions.to_fuzzy_refine,
						},
					},
					-- ... also accepts theme settings, for example:
					-- theme = "dropdown", -- use dropdown theme
					-- theme = { }, -- use own theme spec
					-- layout_config = { mirror=true }, -- mirror preview pane
				},
			},
		})

		telescope.load_extension("live_grep_args")

		--[[ local search in limited in the current directory only
		vim.keymap.set("n", "<leader>pf", function()
		    local Cdir = vim.fn.expand("%:p")
		    if Cdir == "" then
		        builtin.find_files()
		    else
		        Cdir = string.gsub(Cdir, "oil://", "")
		        Cdir = string.gsub(Cdir, "[^/]+%.%w+$", "")
		        print(Cdir)
		        builtin.find_files({ cwd = Cdir })
		    end
		end, {}) ]]

		-- default global search
		vim.keymap.set("n", "<leader>ft", builtin.find_files, { desc = "find files" })
		-- git files in a dir
		vim.keymap.set("n", "<leader>fg", function()
			local Cdir = vim.fn.expand("%:p")
			Cdir = string.gsub(Cdir, "oil://", "")
			Cdir = string.gsub(Cdir, "[^/]+%.%w+$", "")
			-- print(vim.fs.root(0, ".git"))
			-- local Cdir = vim.fs.root(0, ".git")
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
		end, { desc = "Telescope Live grep w args" })
		-- vim.keymap.set("n", "<leader>fd", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
	end,
}
