--[[ vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
	root_markers = { ".git", "flake.nix" },
}) ]]

--[[ vim.filetype.add({
	pattern = {
		["docker%-compose%.ya?ml"] = "yaml.docker-compose",
		["compose%.ya?ml"] = "yaml.docker-compose",
	},
}) ]]

vim.lsp.enable({
	"docker_language_server",
	"clangd",
	"neomake",
	"gopls",
	"emmylua_ls",
	"nixd",
	"statix",
	"yamlls",
	"intelephense",
	"luau_lsp",
	"eslint",
	"ts_ls",
	"bashls",
	"cssls",
	"cssmodules_ls",
	"css_variables",
	"tailwindcss",
	"jsonls",
	"emmet_language_server",
	"html",
	"graphql",
	"solidity",
	"hyprls",
	"helm_ls",
	"asm-lsp",
	"sqls",
	"pyright",
	"nginx",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

			vim.api.nvim_create_autocmd("InsertEnter", {
				buffer = bufnr,
				callback = function()
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				buffer = bufnr,
				callback = function()
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end,
			})
		end
	end,
})

vim.diagnostic.config({
	virtual_lines = { current_line = true },
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	jump = {
		float = "rounded",
		wrap = true,
	},
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		local telescope_builtins = require("telescope.builtin")

		map("gl", function()
			vim.diagnostic.open_float({ border = "rounded" })
		end, "Open Diagnostic Float")

		map("K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, "Hover Documentation")
		map("grd", vim.lsp.buf.declaration, "Goto Declaration")
		map("gra", vim.lsp.buf.code_action, "Code Action")
		map("grn", vim.lsp.buf.rename, "Rename all references")
		map("grr", telescope_builtins.lsp_references, "Lsp references")
		map("gri", vim.lsp.buf.implementation, "Lsp implementation")
		map("gO", telescope_builtins.lsp_document_symbols, "document Symbols")
		map("grw", telescope_builtins.lsp_workspace_symbols, "workspace Symbols")
		map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

		local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

		-- When cursor stops moving: Highlights all instances of the symbol under the cursor
		-- When cursor moves: Clears the highlighting
		--[[ vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = function()
				local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

				for _, client in ipairs(clients) do
					if client.name ~= "asm-lsp" then
						vim.lsp.buf.document_highlight()
					end
				end
			end,
		}) ]]

		--[[ vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		}) ]]
	end,
})

-- Debounce helper
local function debounce(fn, ms)
	local timer_id = nil
	return function(...)
		local args = { ... }
		if timer_id then
			vim.loop.timer_stop(timer_id)
			vim.loop.close(timer_id)
		end
		timer_id = vim.loop.new_timer()
		timer_id:start(ms, 0, function()
			vim.schedule(function()
				fn(unpack(args))
			end)
		end)
	end
end

-- Setup LSP highlights once per buffer
local function setup_highlight(bufnr)
	local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

	-- Debounced document highlight
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		group = group,
		callback = debounce(function()
			vim.lsp.buf.document_highlight()
		end, 150), -- 150ms debounce
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		buffer = bufnr,
		group = group,
		callback = function()
			vim.lsp.buf.clear_references()
		end,
	})
end

-- Call it on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
		for _, client in ipairs(clients) do
			if

				client.capabilities.textDocument ~= nil
				and client.capabilities.textDocument.documentHighlight ~= nil
				and client.capabilities.textDocument.documentHighlight.dynamicRegistration == true
			then
				setup_highlight(args.buf)
			end
			--[[ if client.name ~= "asm-lsp" and client.name ~= "sqls" then
				setup_highlight(args.buf)
			end ]]
		end
	end,
})

-- When LSP detaches: Clears the highlighting
vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
	callback = function(event2)
		vim.lsp.buf.clear_references()
		vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
	end,
})
