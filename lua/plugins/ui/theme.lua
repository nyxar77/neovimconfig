return {
    {
        "hardhackerlabs/theme-vim",
        priority = 999,
        event = "VeryLazy",
        lazy = false,
        config = function()
            function setColorScheme(color)
                return pcall(vim.cmd, "colorscheme " .. color)
            end

            local themes = { "hardhacker", "catppuccin-mocha", "dracula", "gruvbox" }
            for _, theme in pairs(themes) do
                local statusOk, _ = setColorScheme(theme)
                if statusOk then
                    if theme == "hardhacker" then
                        vim.g.lualine_theme = vim.g.hardhacker_lualine_theme
                        vim.g.hardhacker_hide_tilde = 1
                        vim.g.hardhacker_keyword_italic = 1
                    elseif theme == "catppuccin-mocha" then
                        vim.g.lualine_theme = ""
                    elseif theme == "dracula" then
                        vim.g.lualine_theme = "dracula-nvim"
                    elseif theme == "gruvbox" then
                        vim.g.lualine_theme = "gruvbox"
                    end
                    break;
                end
            end
        end
    },
    {
        "Mofiqul/dracula.nvim",
        config = function()
            require "dracula".setup {
                transparent_bg = true,
            }
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require "gruvbox".setup {
                transparent_mode = true,
                overrides = {
                    Pmenu = { link = "Normal" },
                },
            }
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup {
                flavour = "mocha",
                transparent_background = true,
                background = {
                    light = "latte",
                    dark = "mocha",
                },
            }
        end,
    }
}
