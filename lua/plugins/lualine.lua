return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        require("lualine").setup({
            icons_enabled = true,
            options = {
                theme = vim.g.hardhacker_lualine_theme,
            },
            disabled_filetypes = {
                statusline = { "oil" },
                tabline = "oil",
                winbar = { "oil" },
            },
            tabline = {
                lualine_a = {},
                lualine_b = { "filename" },
                lualine_c = {
                    "%=", -- make the indicator center
                    {
                        "harpoon2",
                        indicators = { "e", "z", "a", "s" },
                        active_indicators = { "E", "Z", "A", "S" },
                        color_active = { fg = "#FF00FF" },
                        _separator = " ",
                    },
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = { "tabs" },
            },
            extensions = {},
        })
    end
}
