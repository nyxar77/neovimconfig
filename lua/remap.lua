-- create new tab
vim.keymap.set("n", "<leader>mt", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>")
-- move multiple selected line
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- move next line to the cursor line to the end
vim.keymap.set("n", "J", "mzJ`z")
-- jump forward
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- jump backdward
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- move next tabline
vim.keymap.set("n", "n", "nzzzv")
-- move previous tabline
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- paste in visual mode without overwriting the registery
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to system clipboard
vim.keymap.set({ "n", "x" }, "y", '"+y')

vim.keymap.set({ "n", "v" }, "d", "d")     -- delete and save to clipboard
vim.keymap.set({ "n", "v" }, "D", [["_d]]) -- delete and never save to clipboard

vim.keymap.set("i", "<C-c>", "<Esc>")
--open tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "format the buf" })

-- NOTE: unconfigured quick list
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

--[[ local function is_loclist_open()
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.loclist == 1 then
            return true
        end
    end
    return false
end ]]


-- substitute all words under cursor in the current buffer
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- toggle file executable status
vim.keymap.set("n", "<leader>x", function()
    local file = vim.fn.expand("%")
    if file == "" then
        print("No file to toggle permission.")
        return
    end

    if vim.bo.filetype ~= "oil" then
        local is_executable = vim.fn.getftype(file) == "file" and vim.fn.executable(file) == 1
        -- if true remove executable, false make executable
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
end)


-- in your keymaps or init.lua
vim.api.nvim_create_user_command("Registers", function()
    require("telescope.builtin").registers({
        layout_strategy = "vertical",
        layout_config = {
            width = 0.8,
            height = 0.7,
        },
    })
end, {})

-- Setup Telescope with the delete buffer function
vim.keymap.set("n", "<leader>tb", function()
    local conf = require("telescope.config").values
    local function make_finder()
        local paths = {}
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })

        for _, buf in ipairs(buffers) do
            if buf.name ~= "" then
                if vim.bo[buf.bufnr].modified then
                    buf.name = buf.name .. "*"
                end
                print(buf.name)

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
            initial_mode = "normal",
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
                        -- Close the picker
                        require("telescope.actions").close()
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
                        local is_modified = vim.api.nvim_buf_get_option(buf, "modified")
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
end)

--[[ vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local mode = vim.api.nvim_get_mode().mode
        local filetype = vim.bo.filetype
        if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" then
            vim.cmd('lua vim.lsp.buf.format()')
        else
        end
    end
}) ]]

--[[vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)]]
