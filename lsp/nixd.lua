--[[ return {
	cmd = { "statix", "check", "--stdin" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
} ]]
return {
	cmd = { "nixd", "--inlay-hints=true", "--semantic-tokens=true" },

	filetypes = { "nix" },
	root_markers = {
		".git",
		{
			"flake.nix",
			"flake.lock",
		},
	},
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "alejandra" },
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.nixos.options',
				},
				home_manager = {
					expr = '(builtins.getFlake "/home/nyxar/.config/home-manager").homeConfigurations.nyxar.options',
				},
			},
		},
	},
}
