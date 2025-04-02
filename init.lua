require("options")
require("remap")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print("installing lazy.nvim")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    root = vim.fn.stdpath("data") .. "/lazy",
    ui = {
        border = "rounded",
    },
    install = {
        missing = true,
    },
    checker = {
        enabled = true,
        notify = false
    },
    change_detection = {
        enabled = true,
        notify = false
    },
})
