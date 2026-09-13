vim.g.nyxar_config_start_time = vim.uv.hrtime()

require("config.options")
require("config.remap")
require("config.autocommand")
require("core.lsp")
require("core.lz_stats").setup()
require("plugins")
