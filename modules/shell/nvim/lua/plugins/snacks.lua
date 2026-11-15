local function load_art(name, fallback)
  local path = vim.fn.stdpath("config") .. "/lua/art/" .. name .. ".txt"
  if vim.fn.filereadable(path) == 0 then
    return fallback
  end
  return table.concat(vim.fn.readfile(path), "\n")
end

require("snacks").setup({
  bigfile = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },

  picker = {
    enabled = true,
    matcher = {
      frecency = true,
    },
  },

  dashboard = {
    enabled = true,
    preset = {
      header = load_art("wave", [[  neovim  ]]),
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.smart() end },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
        { icon = " ", key = "g", desc = "Find Text", action = function() Snacks.picker.grep() end },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
    },
  },
})

local map = vim.keymap.set
local p = Snacks.picker

map("n", "<leader><space>", p.smart, { desc = "Smart find files" })
map("n", "<leader>ff", p.files, { desc = "Find files" })
map("n", "<leader>fb", p.buffers, { desc = "Buffers" })
map("n", "<leader>fr", p.recent, { desc = "Recent files" })
map("n", "<leader>sg", p.grep, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", p.grep_word, { desc = "Grep word" })
map("n", "<leader>sh", p.help, { desc = "Help pages" })
map("n", "<leader>sk", p.keymaps, { desc = "Keymaps" })
map("n", "<leader>sc", p.commands, { desc = "Commands" })
map("n", "<leader>:", p.command_history, { desc = "Command history" })
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss notifications" })
