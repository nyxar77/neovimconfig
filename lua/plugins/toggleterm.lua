return {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    lazy = true,
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

        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        --
        -- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
}
