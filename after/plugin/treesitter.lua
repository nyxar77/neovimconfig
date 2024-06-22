require'nvim-treesitter.configs'.setup {
	ensure_installed = {
        "zig",
		"lua",
        "luau",
		"javascript",
		"c",
		"php",
		"css",
        "nix",
        "toml",
        "fish",
        "bash",
        "json",
        "dockerfile",
        "yaml",
        "python",
        "rust",
	},
	sync_install = false,

	auto_install = true;
	highlight = {
		enable = true,

		additional_vim_regex_highlighting = true,
	},
}
