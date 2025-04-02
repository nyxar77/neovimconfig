require "luasnip.loaders.from_vscode".lazy_load()
local luasnip = require "luasnip"
local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
        }),
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" }
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
    }),
})


-- jump forward
vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if luasnip.jumpable(1) then
        luasnip.jump(1)
    end
end)

-- jump backward
vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end)
