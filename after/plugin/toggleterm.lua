require("toggleterm").setup{
    open_mapping = [[<c-;>]],
    presist_mode = true,
    auto_scroll = true,
    direction = "float",
    float_opts = {
        border = "curved",
    },
}
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
