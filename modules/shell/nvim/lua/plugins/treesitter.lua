require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
	callback = function(ev)
		if pcall(vim.treesitter.start, ev.buf) then
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.wo[0][0].foldmethod = nil -- opt-in: "expr", foldexpr = v:lua.vim.treesitter.foldexpr()
		end
	end,
})

local textobjects = require("nvim-treesitter-textobjects")
textobjects.setup({ move = { set_jumps = true }, select = { lookahead = true } })

local move = require("nvim-treesitter-textobjects.move")
local sel = require("nvim-treesitter-textobjects.select")
local map = vim.keymap.set

map({ "n", "x", "o" }, "]f", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function" })
map({ "n", "x", "o" }, "]c", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class" })
map({ "n", "x", "o" }, "[f", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Prev function" })
map({ "n", "x", "o" }, "[c", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Prev class" })

map({ "x", "o" }, "af", function()
	sel.select_textobject("@function.outer", "textobjects")
end, { desc = "around function" })
map({ "x", "o" }, "if", function()
	sel.select_textobject("@function.inner", "textobjects")
end, { desc = "inner function" })
map({ "x", "o" }, "ac", function()
	sel.select_textobject("@class.outer", "textobjects")
end, { desc = "around class" })
map({ "x", "o" }, "ic", function()
	sel.select_textobject("@class.inner", "textobjects")
end, { desc = "inner class" })
