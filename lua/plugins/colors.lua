return {
    {
        "hardhackerlabs/theme-vim",
        priority = 6,
        config = function()
            local colorscheme = "hardhacker"
            local statusOk, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
            if not statusOk then
                statusOk, _ = pcall(vim.cmd, "colorscheme dracula-soft")
                if not statusOk then
                    vim.notify("colorscheme " .. colorscheme .. " Not Found!")
                end
            end
        end
    },
    { "Mofiqul/dracula.nvim" }
}
