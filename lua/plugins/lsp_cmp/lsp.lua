return {
    "williamboman/mason-lspconfig.nvim",
    event = "LspAttach",
    lazy = false,
    config = function()
        local builtin = require "telescope.builtin";
        local lspconfig = require "lspconfig";
        local lsp = require "lsp-zero"
        local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

        local ensure_installed = {
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
            "gopls"
        }
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            automatic_installation = false,
        })
        function Custom_lspconfigs()
            lspconfig.nixd.setup({
                settings = {
                    nixd = {
                        nixpkgs = {
                            expr = "import <nixpkgs> { }",
                        },
                        formatting = {
                            command = { "nixfmt" },
                        },
                        --[[ options = {
            nixos = {
            expr = '(builtins.getFlake "/PATH/TO/FLAKE").nixosConfigurations.CONFIGNAME.options',
            },
            home_manager = {
            expr = '(builtins.getFlake "/PATH/TO/FLAKE").homeConfigurations.CONFIGNAME.options',
            },
            }, ]]
                    },
                },
            })

            lspconfig.taplo.setup({
                capabilities = capabilities,
                settings = {
                    toml = {
                        schemas = {
                            ["https://starship.rs/config-schema.json"] = "starship.toml",
                        },
                        completion = true,
                        hover = true,
                    },
                },
            })

            lspconfig.yamlls.setup({
                capabilities = capabilities,
                settings = {
                    filetypes = { "yaml", "yml" },
                    yaml = {
                        schemas = {
                            -- kubernetes = "*.k8s.{yml,yaml}",
                            ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.3/all.json"] =
                            "*.k8s.{yml,yaml}",
                            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                            ["http://json.schemastore.org/kstomization"] = "kustomization.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                            ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                            "*api*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                            "*docker-compose*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                            "*flow*.{yml,yaml}",
                            -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.3-standalone-strict/all.json"] = "*.k8s.{yml,yaml}",
                        },
                        completion = true,
                        hover = true,
                    },
                },
            })

            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = { 'vim' } }, -- Fix "vim is not defined"
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry = { enable = false }
                    }
                }
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                pattern = { "*.hl", "hypr*.conf" },
                callback = function()
                    vim.bo.filetype = "hyprlang"
                end,
            })

            vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
                pattern = { "*.ejs" },
                callback = function()
                    vim.bo.filetype = "html"
                end,
            })
        end

        Custom_lspconfigs()

        lsp.on_attach(function(_, bufnr)
            vim.keymap.set("n", "<leader>e", function()
                builtin.diagnostics({ bufnr = 5 }) -- Shows diagnostics in Telescope for the current buffer
            end, { buffer = bufnr, remap = false, desc = "diagnostics in Telescope in current buffer" })

            vim.keymap.set("n", ")d", function()
                vim.diagnostic.goto_next()
            end, { buffer = bufnr, remap = false, desc = "next diagnostic" })

            vim.keymap.set("n", "(d", function()
                vim.diagnostic.goto_prev()
            end, { buffer = bufnr, remap = false, desc = "previous diagnostic" })

            vim.keymap.set("n", "gd", function()
                builtin.lsp_definitions()
            end, { buffer = bufnr, remap = false, desc = "go to definition" })

            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, { buffer = bufnr, remap = false, desc = "" })

            vim.keymap.set("n", "<leader>vws", function()
                builtin.lsp_workspace_symbols()
            end, { buffer = bufnr, remap = false, desc = "workspace symbols" })

            vim.keymap.set("n", "gO", function()
                builtin.lsp_document_symbols()
            end, { buffer = bufnr, remap = false, desc = "document symbols" })

            vim.keymap.set("n", "gr", function()
                builtin.lsp_references()
            end, { buffer = bufnr, remap = false, desc = "LSP references" })

            vim.keymap.set("n", "<leader>vca", function()
                vim.lsp.buf.code_action()
            end, { buffer = bufnr, remap = false, desc = "code actions" })

            vim.keymap.set("n", "<leader>vrn", function()
                vim.lsp.buf.rename()
            end, { buffer = bufnr, remap = false, desc = "rename" })

            vim.keymap.set("n", "<leader>vi", function()
                builtin.lsp_implementations()
            end, { buffer = bufnr, remap = false, desc = "LSP implementation" })

            vim.keymap.set("n", "<leader>vtd", function()
                builtin.lsp_type_definitions()
            end, { buffer = bufnr, remap = false, desc = "LSP type definitions" })
        end)
        lsp.setup()
    end
}
