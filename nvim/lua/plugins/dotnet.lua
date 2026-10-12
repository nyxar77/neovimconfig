require("lz.n").load({
	{
		"easy-dotnet.nvim",
		ft = { "cs", "razor", "cshtml" },
		cmd = "Dotnet",
		before = function()
			vim.cmd.packadd("plenary.nvim")
			require("lz.n").trigger_load("telescope.nvim")
			require("lz.n").trigger_load("nvim-dap-ui")
		end,
		after = function()
			require("easy-dotnet").setup({
				picker = "telescope",
				lsp = { preload_roslyn = false, suggest_updates = false },
				debugger = {
					bin_path = vim.fn.exepath("netcoredbg"),
					mem_cpu_usage = false,
				},
				test_runner = { auto_start_testrunner = false },
				auto_bootstrap_namespace = { enabled = false },
			})
		end,
	},
})
