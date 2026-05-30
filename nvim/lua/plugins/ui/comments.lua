require("lz.n").load({
	{
		"nvim-ts-context-commentstring",
		event = "BufReadPost",
		after = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"Comment.nvim",
		event = "BufReadPost",
		load_after = { "nvim-ts-context-commentstring" },
		after = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"todo-comments.nvim",
		event = "BufReadPost",
		after = function()
			require("todo-comments.config").setup({
				keywords = {
					FIX = { icon = " ", color = "error", alt = { "BUG", "FIXIT", "ISSUE" } },
					TODO = { icon = " ", color = "todo", alt = { "DOIT", "DO" } },
					HACK = { icon = " ", color = "hack", alt = { "DANGER", "Attention", "ATT", "ATTENTION" } },
					WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
					PERF = { icon = " ", color = "performance", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "note", alt = { "INFO" } },
					TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				},
				colors = {
					error = { "DiagnosticError", "ErrorMsg", "#FF0000" },
					warning = { "DiagnosticWarn", "WarningMsg", "#FFA63D" },
					hack = { "#FF6347" },
					todo = { "DiagnosticInfo", "#00BFFF" },
					note = { "#ADFF2F" },
					performance = { "#7FFFD4" },
					test = { "DiagnosticTest", "#DDA0DD" },
				},
			})
		end,
	},
})
