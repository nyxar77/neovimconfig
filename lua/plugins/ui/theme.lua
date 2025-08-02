return {
    {
        "hardhackerlabs/theme-vim",
        priority = 999,
        event = "VeryLazy",
        lazy = false,
        config = function()
            local themes = { "hardhacker", "catppuccin-macchiato", "dracula-soft", "gruvbox" }
            for _, theme in pairs(themes) do
                local statusOk, _ = pcall(vim.cmd, "colorscheme " .. theme)
                if statusOk then
                    if theme == "hardhacker" then
                        vim.g.lualine_theme = vim.g.hardhacker_lualine_theme
                    elseif theme == "catppuccin-macchiato" then
                        vim.g.lualine_theme = ""
                    elseif theme == "dracula-soft" then
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
            require "catppuccin".setup {
                transparent_background = true,
            }
        end
    }

}
