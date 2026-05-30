return {
	cmd = { "taplo" },
	filetypes = "toml",
	settings = {
		toml = {
			schemas = {
				["https://starship.rs/config-schema.json"] = "starship.toml",
			},
			completion = true,
			hover = true,
		},
	},
	root_markers = { ".taplo.toml", "taplo.toml", ".git" },
}
