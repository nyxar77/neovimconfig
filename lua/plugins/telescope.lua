return {
    "nvim-telescope/telescope.nvim",
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
                file_ignore_patterns = { "node_modules/*", "build/*", ".git/*", "dist/*", ".exe", ".apk", ".tmp", ".swp", ".png", ".jpg", ".jpeg" },
                layout_config = {
                    preview_width = 0.6,
                    width = 0.8,
                    height = 0.8,
                    preview_cutoff = 120,
                },
            },
        })

        -- local search in limited in the current directory only
        --[[ vim.keymap.set("n", "<leader>pf", function()
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
            builtin.git_files({ cwd = Cdir })
        end, { desc = "find git-tracked files in current dir" })

        -- look for content inside the files
        -- vim.keymap.set("n", "<leader>fs", function()
        --     builtin.live_grep({})
        -- end, { desc = "grep in files" })
        vim.keymap.set("n", "<leader>fs", function()
            local cwd = vim.fn.expand("%:p")
            if cwd == "" then cwd = vim.fn.getcwd() end
            cwd = cwd:gsub("oil://", "")
            cwd = string.gsub(cwd, "[^/]+%.%w+$", "")
            require("telescope.builtin").live_grep({ cwd = cwd })
        end, { desc = "Live grep" })
    end
}
