vim.loader.enable()

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.nyxar_config_start_time = vim.uv.hrtime()

require("config.options")
require("config.remap")
require("config.autocommand")
require("core.lz_stats").setup()
require("plugins")
require("core.lsp")
