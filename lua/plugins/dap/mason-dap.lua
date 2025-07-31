return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = { "python", "bash", "php", "js", "delve", "codelldb" }, -- choose what you need
            automatic_installation = false,
        })
    end,
}


--NOTE: all available Dap adapters: https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
