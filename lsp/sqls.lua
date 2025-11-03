return {
	command = { "sqls" },
	filetypes = { "sql" },
	settings = {
		--[[ sqls = {
			connections = {
				{
					driver = "mysql",
					dataSourceName = "nyxar@unix(/var/run/mysqld/mysqld.sock)/test",
				},
				 {
					driver = "postgresql",
					dataSourceName = "host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable",
				},
			},
		}, ]]
	},
}
