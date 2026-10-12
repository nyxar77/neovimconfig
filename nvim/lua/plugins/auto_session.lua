require("lz.n").load({
	{
		"auto-session",
		lazy = false,
		after = function()
			local launched_with_args = vim.fn.argc() > 0
			local saved_notebook_buftypes = {}

			local function prepare_notebooks_for_session()
				saved_notebook_buftypes = {}
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local path = vim.api.nvim_buf_get_name(buf)
					if path:match("%.ipynb$") and vim.bo[buf].buftype == "acwrite" then
						saved_notebook_buftypes[buf] = "acwrite"
						vim.bo[buf].buftype = ""
					end
				end
			end

			local function restore_notebooks_after_session_save()
				for buf, buftype in pairs(saved_notebook_buftypes) do
					if vim.api.nvim_buf_is_valid(buf) then
						vim.bo[buf].buftype = buftype
					end
				end
				saved_notebook_buftypes = {}
			end

			local function reload_uninitialised_notebooks()
				vim.schedule(function()
					local Notebook = require("jupynvim.notebook")
					local visible_notebook = false
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local path = vim.api.nvim_buf_get_name(buf)
						if path:match("%.ipynb$") then
							visible_notebook = true
							if not Notebook.get(buf) then
								vim.api.nvim_win_call(win, function()
									vim.cmd("edit! " .. vim.fn.fnameescape(path))
								end)
							end
						end
					end

					-- Recover sessions written by the old workaround, which kept the
					-- notebook in :badd but omitted its window entirely.
					local current = vim.api.nvim_get_current_buf()
					if
						not visible_notebook
						and vim.api.nvim_buf_get_name(current) == ""
						and not vim.bo[current].modified
						and vim.api.nvim_buf_line_count(current) == 1
						and vim.api.nvim_buf_get_lines(current, 0, 1, false)[1] == ""
					then
						local notebooks = {}
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							local path = vim.api.nvim_buf_get_name(buf)
							if path:match("%.ipynb$") then
								table.insert(notebooks, path)
							end
						end
						if #notebooks == 1 then
							vim.cmd.edit(vim.fn.fnameescape(notebooks[1]))
						end
					end
				end)
			end

			require("auto-session").setup({
				auto_restore = launched_with_args,
				auto_save = launched_with_args,
				pre_save_cmds = { prepare_notebooks_for_session },
				post_save_cmds = { restore_notebooks_after_session_save },
				post_restore_cmds = { reload_uninitialised_notebooks },
				suppressed_dirs = { "~/", "/", "/tmp" },
				session_lens = {
					picker = "snacks",
				},
			})

			vim.keymap.set("n", "<leader>os", "<cmd>AutoSession search<CR>", {
				desc = "search sessions",
			})
			vim.keymap.set("n", "<leader>oa", "<cmd>AutoSession toggle<CR>", {
				desc = "toggle session autosave",
			})
		end,
	},
})
