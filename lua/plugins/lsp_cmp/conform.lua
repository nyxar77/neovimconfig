return {
    "stevearc/conform.nvim",
    branch = "master",
    event = "BufWritePre",
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                yaml = { "yamlfmt" },
                php = { "prettier" },
                graphql = { "prettier" },
                markdown = { "prettier" },
                nix = { "alejandra" },
                hypr = { "hyprls" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
        })
    end
}
