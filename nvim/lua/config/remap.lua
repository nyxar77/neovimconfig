vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

--[[ vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "new tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>", { desc = "previous tab" }) ]]

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "P", [["_dP]], { desc = "paste in x mode without overwriting the registery" })

vim.keymap.set({ "n", "v" }, "Y", '"+y', { desc = "yank to system" })

vim.keymap.set({ "n", "v" }, "D", '"dd', { desc = "del & save to nvim D registery" })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]],
	{ desc = "substitute under cursor" }
)

vim.keymap.set("n", "<leader>x", function()
	local file = vim.fn.expand("%")
	if file == "" then
		print("No file to toggle permission.")
		return
	end

	if vim.bo.filetype ~= "oil" then
		local is_executable = vim.fn.getftype(file) == "file" and vim.fn.executable(file) == 1
		local action = is_executable and "remove executable" or "make executable"
		local answer = vim.fn.input("Do you want to " .. action .. "? (y/n): ")
		if answer:lower() == "y" then
			local command = is_executable and "!chmod -x " .. file or "!chmod +x " .. file
			vim.cmd(command)
		else
			print("action Aborted")
		end
	else
		print("oil filetype is not accepted.")
	end
end, { silent = true, desc = "toggle executable mode" })

vim.keymap.set("n", "<leader>tb", function()
	require("lz.n").trigger_load("telescope.nvim")
	local conf = require("telescope.config").values
	local function make_finder()
		local paths = {}
		local buffers = vim.fn.getbufinfo({ buflisted = 1 })

		for _, buf in ipairs(buffers) do
			if buf.name ~= "" then
				if vim.bo[buf.bufnr].modified then
					buf.name = buf.name .. "*"
				end

				table.insert(paths, buf)
			end
		end

		return require("telescope.finders").new_table({
			results = paths,
			entry_maker = function(entry)
				local display_name = vim.fn.fnamemodify(entry.name, ":t")
				return {
					value = entry.name,
					display = display_name,
					ordinal = entry.name,
					bufnr = entry.bufnr,
				}
			end,
		})
	end
	require("telescope.pickers")
		.new({}, {
			finder = make_finder(),
			prompt_title = "open buffers",
			initial_mode = "insert",
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
			color_devicons = true,
			layout_config = {
				preview_width = 0.6,
				width = 0.8,
				height = 0.8,
			},
			mappings = {
				i = {
					["<Esc>"] = function(prompt_buffer_number)
						local state = require("telescope.actions.state")
						local current_picker = state.get_current_picker(prompt_buffer_number)
						require("telescope.actions").close(prompt_buffer_number)
						current_picker:refresh(make_finder())
					end,
				},
			},
			attach_mappings = function(prompt_buffer_number, map)
				map("n", "d", function()
					local state = require("telescope.actions.state")
					local selection = state.get_selected_entry()
					local current_picker = state.get_current_picker(prompt_buffer_number)
					if selection then
						local buf = selection.bufnr
						local is_modified = vim.bo[buf].modified
						if is_modified then
							print("Buffer is modified! Cannot delete without saving.")
							return
						end
						vim.cmd("bdelete " .. buf)
						current_picker:refresh(make_finder())
					end
				end)
				return true
			end,
		})
		:find()
end, { desc = "Telescope Buffer" })
