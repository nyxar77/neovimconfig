local lsp = require("lsp-zero")

local lsp_list= {
        "luau_lsp",
	    "lua_ls",
        "nil_ls",
		"eslint",
	    "tsserver",
		"bashls",
		"intelephense",
		"cssls",
		"cssmodules_ls",
		"css_variables",
        "tailwindcss",
        "jsonls",
        --"nixpkgs-fmt",
        "docker_compose_language_service",
        "dockerls",
	}


require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = lsp_list,
})



local lspconfig = require("lspconfig")

for _, server in ipairs(lsp_list) do

    lspconfig[server].setup({})

end

--[[ 
local cmd = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-Tab>'] = cmp.mapping.confirm({select = true}),
    ['<C-space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.lsp.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.lsp.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.lsp.diagnostic.goto_prev() end, opts)

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup();]]--
