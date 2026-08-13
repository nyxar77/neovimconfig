return {
	cmd = { "sqls" },
	filetypes = { "sql", "mysql" },
	root_markers = { "config.yml" },
	settings = {
		sqls = {
			connections = {
				{
					driver = "mysql",
					dataSourceName = "nyxar@unix(/var/run/mysqld/mysqld.sock)/test",
				},
			},
		},
	},
}
