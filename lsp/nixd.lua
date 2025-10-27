return {
	cmd = { "nixd" },

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
