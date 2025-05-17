return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "letieu/harpoon-lualine" },
    config = function()
        if vim.g.keyboardLayout == "azerty" then
            Indicators = { "e", "z", "a", "s" }
        else
            Indicators = { "e", "w", "q", "s" }
        end
        local harpoon = require("harpoon")
        harpoon:setup({
            settings = {
                save_on_toggle = false,
                sync_on_ui_close = true,
                key = function()
                    return vim.loop.cwd()
                end,
            },
        })

        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local make_finder = function()
                local paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(paths, item.value)
                end
                return require("telescope.finders").new_table({
                    results = paths,
                })
            end

            require("telescope.pickers")
                .new({}, {
                    finder = make_finder(),
                    prompt_title = "Harpoon",
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                    layout_config = {
                        preview_width = 0.6,
                        width = 0.8,
                        height = 0.8,
                        preview_cutoff = 120,
                    },
                    attach_mappings = function(prompt_buffer_number, map)
                        -- The keymap you need
                        map("n", "d", function()
                            local state = require("telescope.actions.state")
                            local selected_entry = state.get_selected_entry()
                            local current_picker = state.get_current_picker(prompt_buffer_number)
                            harpoon:list():remove_at(selected_entry.index)
                            current_picker:refresh(make_finder())
                        end)
                        return true
                    end,
                })
                :find()
        end

        vim.keymap.set("n", "M", function()
            toggle_telescope(harpoon:list())
        end, { desc = "Open harpoon window" })

        vim.keymap.set("n", "<leader>a", function()
            local Cdir = vim.fn.expand("%:p")
            if string.match(Cdir, "oil://") == nil then
                harpoon:list():add()
            else
                vim.notify("you can't add this")
            end
        end)

        vim.keymap.set("n", "m" .. Indicators[1], function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "m" .. Indicators[2], function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", "m" .. Indicators[3], function()
            harpoon:list():select(3)
        end)
        vim.keymap.set("n", "m" .. Indicators[4], function()
            harpoon:list():select(4)
        end)
        vim.keymap.set("n", "<C-S-P>", function()
            harpoon:list():prev()
        end)
        vim.keymap.set("n", "<C-S-N>", function()
            harpoon:list():next()
        end)
    end
}
