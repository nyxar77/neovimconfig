-- The packaged configuration starts nvim-treesitter. The guarded packadd also
-- lets repository checks run against an older, still-activated generation.
pcall(vim.cmd.packadd, "nvim-treesitter")
vim.cmd.packadd("nvim-treesitter-textobjects")

local filetypes = {
	"asm",
	"bash",
	"blade",
	"c",
	"cpp",
	"css",
	"desktop",
	"diff",
	"dockerfile",
	"fish",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"graphql",
	"html",
	"hyprlang",
	"ini",
	"java",
	"javascript",
	"javascriptreact",
	"json",
	"latex",
	"lua",
	"luau",
	"markdown",
	"markdown_inline",
	"nginx",
	"nix",
	"php",
	"python",
	"rasi",
	"rust",
	"scss",
	"solidity",
	"toml",
	"tsx",
	"typescript",
	"typescriptreact",
	"typst",
	"xml",
	"yaml",
	"yuck",
	"zig",
}

local group = vim.api.nvim_create_augroup("nyxar-treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = filetypes,
	callback = function(args)
		local ok = pcall(vim.treesitter.start, args.buf)
		if not ok then
			vim.notify("No Tree-sitter parser for " .. args.match, vim.log.levels.DEBUG)
			return
		end

		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("nvim-treesitter-textobjects").setup({
	move = { set_jumps = true },

	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "<c-v>",
		},
		include_surrounding_whitespace = false,
	},
})

local selections = {
	af = "@function.outer",
	["if"] = "@function.inner",
	ac = "@class.outer",
	ic = "@class.inner",
	aP = "@parameter.outer",
	iP = "@parameter.inner",
	aC = "@conditional.outer",
	iC = "@conditional.inner",
	al = "@loop.outer",
	il = "@loop.inner",
}

for lhs, capture in pairs(selections) do
	vim.keymap.set({ "x", "o" }, lhs, function()
		require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
	end, { desc = "select " .. capture:sub(2) })
end
