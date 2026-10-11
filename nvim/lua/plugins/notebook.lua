vim.g.molten_auto_open_output = false
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
vim.g.molten_virt_lines_off_by_1 = true
vim.g.molten_virt_text_output = true
vim.g.molten_wrap_output = true

require("jupytext").setup({
	style = "markdown",
	output_extension = "md",
	force_ft = "markdown",
})

require("lz.n").load({
	{
		"quarto-nvim",
		ft = { "markdown" },
		before = function()
			vim.cmd.packadd("image.nvim")
			vim.cmd.packadd("otter.nvim")
		end,
		after = function()
			require("image").setup({
				backend = "kitty",
				processor = "magick_cli",
				integrations = {},
				max_width = 100,
				max_height = 12,
				max_width_window_percentage = math.huge,
				max_height_window_percentage = math.huge,
				window_overlap_clear_enabled = true,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "" },
			})

			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					chunks = "all",
					languages = { "python" },
					diagnostics = {
						enabled = true,
						triggers = { "BufWritePost" },
					},
					completion = { enabled = true },
				},
				codeRunner = {
					enabled = true,
					default_method = "molten",
					never_run = { "yaml" },
				},
			})
		end,
	},
})

local notebook_group = vim.api.nvim_create_augroup("nyxar-notebooks", { clear = true })

local function is_notebook(bufnr)
	return vim.api.nvim_buf_get_name(bufnr):match("%.ipynb$") ~= nil
end

local function notebook_kernel(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil
	end

	local decoded_ok, notebook = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decoded_ok then
		return nil
	end

	return notebook.metadata and notebook.metadata.kernelspec and notebook.metadata.kernelspec.name or nil
end

local function initialise_notebook(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or not is_notebook(bufnr) or vim.b[bufnr].molten_initialised then
		return
	end

	local path = vim.api.nvim_buf_get_name(bufnr)
	local kernel = notebook_kernel(path)
	local kernels = vim.fn.MoltenAvailableKernels()

	if not kernel or not vim.tbl_contains(kernels, kernel) then
		return
	end

	vim.api.nvim_buf_call(bufnr, function()
		vim.cmd.MoltenInit(kernel)
		vim.cmd.MoltenImportOutput()
	end)
	vim.b[bufnr].molten_initialised = true
end

vim.api.nvim_create_autocmd("FileType", {
	group = notebook_group,
	pattern = "markdown",
	callback = function(args)
		if not is_notebook(args.buf) then
			return
		end

		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(args.buf) then
				return
			end

			require("quarto").activate()
			local runner = require("quarto.runner")
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
			end

			map("n", "<leader>ji", "<cmd>MoltenInit<cr>", "notebook: select kernel")
			map("n", "<leader>jr", runner.run_cell, "notebook: run cell")
			map("v", "<leader>jr", runner.run_range, "notebook: run selection")
			map("n", "<leader>ja", runner.run_above, "notebook: run cells above")
			map("n", "<leader>jA", runner.run_all, "notebook: run all cells")
			map("n", "<leader>jl", runner.run_line, "notebook: run line")
			map("n", "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<cr>", "notebook: open output")
			map("n", "<leader>jh", "<cmd>MoltenHideOutput<cr>", "notebook: hide output")
			map("n", "<leader>jd", "<cmd>MoltenDelete<cr>", "notebook: delete cell output")

			initialise_notebook(args.buf)
		end)
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = notebook_group,
	pattern = "*.ipynb",
	callback = function()
		if require("molten.status").initialized() == "Molten" then
			vim.cmd("MoltenExportOutput!")
		end
	end,
})
