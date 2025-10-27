return {
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		config = function()
			--NOTE: comments highlight
			require("todo-comments.config").setup({
				keywords = {
					FIX = { icon = " ", color = "error", alt = { "BUG", "FIXIT", "ISSUE" } },
					TODO = { icon = " ", color = "todo", alt = { "DOIT", "DO" } },
					HACK = { icon = " ", color = "hack", alt = { "DANGER", "Attention", "ATT", "ATTENTION" } },
					WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
					PERF = { icon = " ", color = "performance", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "note", alt = { "INFO" } },
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

			--DO:
			--PERF:
			--NOTE:
			--HACK:
			--BUG:
			--WARNING:
			--TEST:
		end,
	},
}
