require("which-key").setup({
	preset = "helix",
	spec = {
		{
			mode = { "n", "x" },
			{ "<leader>c", group = "code" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>s", group = "search" },
			{ "<leader>x", group = "diagnostics/quickfix" },
			{ "<leader>u", group = "ui" },
			{ "<leader><tab>", group = "tabs" },
			{ "[", group = "prev" },
			{ "]", group = "next" },
			{ "g", group = "goto" },
			{ "gs", group = "surround" },
		},
	},
})

require("lualine").setup({
	options = {
		theme = "gruvbox",
		globalstatus = true,
		disabled_filetypes = { statusline = { "snacks_explorer" } },
	},
})

require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		always_show_bufferline = false,
	},
})
local bmap = vim.keymap.set
bmap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
bmap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
bmap("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
	},
})
