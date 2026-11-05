require("snacks").setup({
	bigfile = { enabled = true },
	explorer = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true, timeout = 3000 },
	picker = { enabled = true },
	quickfile = { enabled = true },
	words = { enabled = true },
})

local map = vim.keymap.set
local p = Snacks.picker

map("n", "<leader><space>", p.files, { desc = "Find files" })
map("n", "<leader>ff", p.files, { desc = "Find files" })
map("n", "<leader>fb", p.buffers, { desc = "Buffers" })
map("n", "<leader>fr", p.recent, { desc = "Recent files" })
map("n", "<leader>sg", p.grep, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", p.grep_word, { desc = "Grep word" })
map("n", "<leader>sh", p.help, { desc = "Help pages" })
map("n", "<leader>sk", p.keymaps, { desc = "Keymaps" })
map("n", "<leader>sc", p.commands, { desc = "Commands" })
map("n", "<leader>:", p.command_history, { desc = "Command history" })
map("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "Explorer" })

map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })
map("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss notifications" })
