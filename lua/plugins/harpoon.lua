return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	event = { "BufReadPost", "VeryLazy" },
	lazy = false,
	dependencies = { "letieu/harpoon-lualine" },
	config = function()
		if vim.g.keyboardLayout == "azerty" then
			Indicators = { "a", "z", "e", "s" }
		else
			Indicators = { "q", "w", "e", "s" }
		end
		local harpoon = require("harpoon")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions_state = require("telescope.actions.state")

		vim.keymap.set("n", "M", function()
			local function make_finder()
				local items = {}
				-- print(vim.inspect(harpoon:list().items))
				for i, item in pairs(harpoon:list().items) do
					table.insert(items, {
						path = item.value,
						harpoon_index = i,
					})
				end

				return finders.new_table({
					results = items,
					entry_maker = function(entry)
						return {
							value = entry.path,
							display = entry.path,
							ordinal = entry.path,
							harpoon_index = entry.harpoon_index,
							path = entry.path,
						}
					end,
				})
			end

			pickers
				.new({}, {
					prompt_title = "Harpoon Files",
					finder = make_finder(),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					layout_config = {
						preview_width = 0.6,
						width = 0.8,
						height = 0.8,
						preview_cutoff = 120,
					},
					attach_mappings = function(prompt_bufnr, map)
						map("n", "d", function()
							local selection = actions_state.get_selected_entry()
							if selection and selection.harpoon_index then
								harpoon:list():remove_at(selection.harpoon_index)
								local picker = actions_state.get_current_picker(prompt_bufnr)
								picker:refresh(make_finder())
							end
						end)
						return true
					end,
				})
				:find()
		end, { desc = "open harpoon window" })

		vim.keymap.set("n", "<leader>a", function()
			local Cdir = vim.fn.expand("%:p")
			if string.match(Cdir, "oil://") == nil then
				harpoon:list():add()
			else
				vim.notify("you can't add this")
			end
		end, { desc = "add file to harpoon list" })

		vim.keymap.set("n", "m" .. Indicators[1], function()
			harpoon:list():select(1)
		end, { desc = "Switch to 1" })
		vim.keymap.set("n", "m" .. Indicators[2], function()
			harpoon:list():select(2)
		end, { desc = "Switch to 2" })
		vim.keymap.set("n", "m" .. Indicators[3], function()
			harpoon:list():select(3)
		end, { desc = "Switch to 3" })
		vim.keymap.set("n", "m" .. Indicators[4], function()
			harpoon:list():select(4)
		end, { desc = "Switch to 4" })
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Switch to previous item" })
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Switch to next item" })
	end,
}
