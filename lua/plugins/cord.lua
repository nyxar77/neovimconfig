return {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    --opts = {}, calls require('cord').setup()
}
