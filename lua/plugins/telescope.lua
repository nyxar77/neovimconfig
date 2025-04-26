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
                file_ignore_patterns = { "node_modules/*", "build/*", ".git/*", "dist/*", ".exe", ".apk", ".tmp", ".swp" },
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
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        -- git files in a dir
        vim.keymap.set("n", "<leader>fg", function()
            local Cdir = vim.fn.expand("%:p")
            Cdir = string.gsub(Cdir, "oil://", "")
            Cdir = string.gsub(Cdir, "[^/]+%.%w+$", "")
            builtin.git_files({ cwd = Cdir })
        end, {})

        -- look for content inside the files
        vim.keymap.set("n", "<leader>fs", function()
            builtin.live_grep({})
        end)
    end

}
