return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    lazy = true,
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    config = function()
        require("which-key").setup({
            win = {
                no_overlap = true,
                padding = { 1, 2 },
                title = true,
                title_pos = "center",
                zindex = 1000,
                bo = {},
                wo = {},
                border = "rounded", -- 👈 this is the key line
            },

            layout = {
                width = { min = 20, max = 40 }, -- controls total column width
                height = { min = 4, max = 10 }, -- ⬅️ you can add this manually
                spacing = 2,                    -- space between columns
            },

        })
    end
}
