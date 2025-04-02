return {
    {
        "hrsh7th/nvim-cmp",
        priority = 100,
        lazy = false,
        dependencies = {
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "williamboman/mason.nvim" },
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason-lspconfig.nvim", event = "LspAttach" },
            { "VonHeikemen/lsp-zero.nvim",         after = "mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip",                  event = "InsertEnter" },
            { 'saadparwaiz1/cmp_luasnip',          after = "LuaSnip",             lazy = true },
            { "rafamadriz/friendly-snippets",      lazy = true },
            { "onsails/lspkind.nvim" }
        },
        config = function()
            require "plugins.completions.lsp"
            require "plugins.completions.cmp"
        end
    },
}
