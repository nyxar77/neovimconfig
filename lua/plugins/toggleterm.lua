return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup {
            open_mapping = [[<c-;>]],
            presist_mode = true,
            auto_scroll = true,
            direction = "float",
            float_opts = {
                border = "curved",
            },
            highlights = {
                FloatBorder = {
                    guifg = "#E965A5",
                }, }
        }
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true })

        function _Lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>g", "<cmd>lua _Lazygit_toggle()<CR>", { noremap = true, silent = true })
    end
}
