vim.lsp.config("*", {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    },
    root_markers = { ".git" },
})

vim.lsp.enable({
    "clangd",
    "gopls",
    "lua_ls",
    "nixd",
    "yamlls",
    "intelephense",
    "luau_lsp",
    "eslint",
    "ts_ls",
    "bashls",
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
    "helm_ls",
})

vim.diagnostic.config({

    virtual_lines = { current_line = true },
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        local telescope_builtins = require("telescope.builtin")

        map("gl", function()
            vim.diagnostic.open_float({ border = "rounded" })
        end, "Open Diagnostic Float")

        map("K", function()
            vim.lsp.buf.hover({ border = "rounded" })
        end, "Hover Documentation")
        map("grd", vim.lsp.buf.declaration, "Goto Declaration")
        map("gra", vim.lsp.buf.code_action, "Code Action")
        map("grn", vim.lsp.buf.rename, "Rename all references")
        map("grr", telescope_builtins.lsp_references, "Lsp references")
        map("gri", vim.lsp.buf.implementation, "Lsp implementation")
        map("g0", telescope_builtins.lsp_document_symbols, "document Symbols")
        map("grw", telescope_builtins.lsp_workspace_symbols, "workspace Symbols")
        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

        -- When cursor stops moving: Highlights all instances of the symbol under the cursor
        -- When cursor moves: Clears the highlighting
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        -- When LSP detaches: Clears the highlighting
        vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
            end,
        })
    end,
})

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
