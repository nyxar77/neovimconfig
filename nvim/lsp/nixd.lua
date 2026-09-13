local home = vim.env.HOME

return {
	cmd = {
		"nixd",
		"--inlay-hints=true",
	},

	filetypes = { "nix" },

	root_markers = {
		"flake.nix",
		".git",
	},

	-- nixd's token classes currently collapse keys and function definitions
	-- into `method`, and parameters into `regexp`. Tree-sitter provides the
	-- more useful syntax hierarchy; all other nixd features remain enabled.
	on_init = function(client)
		client.server_capabilities.semanticTokensProvider = nil
	end,

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
