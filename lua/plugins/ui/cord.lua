-- CORD: discord activity plugin
return {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    lazy = true,
    --opts = {}, calls require('cord').setup()
}
