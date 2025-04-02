return {
    "sontungexpt/url-open",
    branch = "mini",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
        require("url-open").setup({
            open_only_when_cursor_on_url = true,
            highlight_url = {
                all_urls = {
                    enabled = true,
                    fg = "#B0E0E6",
                },
                cursor_move = {
                    enabled = true,
                    fg = "#A3CFFF",
                    bg = nil,
                    underline = true,
                },
            },
        })

        vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")

        --TEST: https://www.youtube.com/watch?v=ZHgyQGoeaB0
    end
}
