require("lz.n").load({
	{
		"lazydev.nvim",
		ft = "lua",
		after = function()
			local library = {
				"nvim-dap-ui",
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			}

			-- Hyprland ships LuaLS stubs for its `hl` API. LazyDev's `files`
			-- selector keeps them out of every Lua workspace except hyprland.lua.
			local hyprland_stub_paths = {
				"/run/current-system/sw/share/hypr/stubs",
				"/usr/share/hypr/stubs",
			}
			if vim.env.HYPRLAND_LUA_STUBS then
				table.insert(hyprland_stub_paths, 1, vim.env.HYPRLAND_LUA_STUBS)
			end
			for _, path in ipairs(hyprland_stub_paths) do
				if path and vim.uv.fs_stat(path) then
					library[#library + 1] = { path = path, files = { "hyprland.lua" } }
					break
				end
			end

			require("lazydev").setup({
				library = library,
			})
		end,
	},
})
