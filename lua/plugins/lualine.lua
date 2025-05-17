return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        if vim.g.keyboardLayout == "azerty" then
            Indicators = { "e", "z", "a", "s" }
            Active_indicators = { "E", "Z", "A", "S" }
        else
            Indicators = { "e", "w", "q", "s" }
            Active_indicators = { "E", "W", "Q", "S" }
        end
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
                        indicators = Indicators,
                        active_indicators = Active_indicators,
                        color_active = { fg = "#fc770a" },
                        _separator = " ",
                    },
                },
                lualine_x = {},
                lualine_y = {
                    {
                        function()
                            return vim.g.keyboardLayout or "?"
                        end,
                        color = { fg = "#fc770a" },
                        separator = " ",
                    }
                },
                lualine_z = { "tabs" },
            },
            extensions = {},
        })
    end
}
