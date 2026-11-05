require("config.options")
require("config.keymaps")
require("config.autocmds")

vim.cmd.colorscheme("gruvbox")

require("plugins.treesitter")
require("plugins.completion")
require("plugins.snacks")
require("plugins.editor")
require("plugins.ui")
require("plugins.lsp")
