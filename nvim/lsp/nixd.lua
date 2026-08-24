local home = vim.env.HOME

return {
	cmd = {
		"nixd",
		"--inlay-hints=true",
		"--semantic-tokens=true",
	},

	filetypes = { "nix" },

	root_markers = {
		"flake.nix",
		".git",
	},

	settings = {
		nixd = {
			nixpkgs = {
				expr = 'import (builtins.getFlake "/etc/nixos").inputs.nixpkgs { }',
			},

			--[[ formatting = {
				command = { "nixfmt" },
			}, ]]

			diagnostic = {
				suppress = {
					"sema-extra-with",
				},
			},

			options = {
				nixos = {
					expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.nixos.options',
				},

				home_manager = {
					expr = string.format(
						'(builtins.getFlake "%s/.config/home-manager").homeConfigurations.nyxar.options',
						home
					),
				},
			},
		},
	},
}
