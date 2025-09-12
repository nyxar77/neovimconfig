return {
    "williamboman/mason.nvim",
    dependencies = { "VonHeikemen/lsp-zero.nvim", after = "mason-lspconfig.nvim" },
    config = function()
        local lspconfig = require "lspconfig";
        local lsp_list = {
            "clangd",
            "cmake-language-server",
            "luau_lsp",
            "lua_ls",
            "eslint",
            "ts_ls",
            "bashls",
            "intelephense",
            "cssls",
            "cssmodules_ls",
            "css_variables",
            "tailwindcss",
            "jsonls",
            "docker_compose_language_service",
            "dockerls",
            "emmet_language_server",
            "html",
            "graphql",
            "solidity",
            "hyprls",
            "yamlls",
            "helm_ls",
            "taplo",
            "gopls",

        }
        local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
        require("mason").setup({
            install_root_dir = vim.fn.stdpath("data") .. "/mason",
            ui = {
                check_outdated_packages_on_open = true,
                border = "rounded",
            },
            PATH = "prepend",
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
            registries = {
                "github:mason-org/mason-registry",
            },

            providers = {
                "mason.providers.registry-api",
                "mason.providers.client",
            },
            github = {
                download_url_template = "https://github.com/%s/releases/download/%s/%s",
            },
            pip = {
                upgrade_pip = false,
            },
        })
    end

}
