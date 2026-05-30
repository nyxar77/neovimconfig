---@type vim.lsp.Config
return {
	cmd = "yaml-language-server",
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
	root_markers = {
		".git",
	},
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
	end,
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			--[[ schemas = require("schemastore").yaml.schemas(),
			schemaStore = {
				-- You must disable built-in schemaStore support if you want to use
				-- this plugin and its advanced options like `ignore`.
				enable = true,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			}, ]]
			schemas = {
				-- kubernetes = "*.k8s.{yml,yaml}",
				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
				["http://json.schemastore.org/kstomization"] = "kustomization.{yml,yaml}",
				["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
				["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
				["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
				["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json"] = "*.k8s.{yml,yaml}",
			},
			format = { enable = true },
			completion = true,
			validate = true,
			hover = true,
			customTags = { "!Ref", "!Sub", "!GetAtt", "!Join", "!ImportValue", "!Base64" },
			singleFileValidation = true,
		},
	},
}
