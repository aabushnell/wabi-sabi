require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = false } })
require("mini.ai").setup({ n_lines = 500 })

require("flash").setup({})
local map = vim.keymap.set
map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash treesitter" })
map("o", "r", function()
	require("flash").remote()
end, { desc = "Remote flash" })

require("trouble").setup({})
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "[q", function()
	---@diagnostic disable-next-line: missing-parameter, missing-fields
	require("trouble").prev({ skip_groups = true, jump = true })
end, { desc = "Prev trouble item" })
map("n", "]q", function()
	---@diagnostic disable-next-line: missing-parameter, missing-fields
	require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Next trouble item" })
