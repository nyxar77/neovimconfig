return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
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
					"--trim", -- add this value
				},
				file_ignore_patterns = {
					"^node_modules/",
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
		})

		-- local search in limited in the current directory only
		-- vim.keymap.set("n", "<leader>pf", function()
		--     local Cdir = vim.fn.expand("%:p")
		--     if Cdir == "" then
		--         builtin.find_files()
		--     else
		--         Cdir = string.gsub(Cdir, "oil://", "")
		--         Cdir = string.gsub(Cdir, "[^/]+%.%w+$", "")
		--         print(Cdir)
		--         builtin.find_files({ cwd = Cdir })
		--     end
		-- end, {})

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
	end,
}
