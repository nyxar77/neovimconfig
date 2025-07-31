return {
    "stevearc/oil.nvim",
    opts = {},
    config = function()
        local oil = require("oil")

        oil.setup({
            delete_to_trash = true,
            keymaps = {
                ["<C-c>"] = { "actions.close", mode = "n" },
                ["<Esc>"] = { "actions.close", mode = "n", desc = "mapping to <C-c>" },
            },
        })

        vim.keymap.set("n", "-", oil.open)
        vim.keymap.set("n", "+", oil.close)
    end
}
