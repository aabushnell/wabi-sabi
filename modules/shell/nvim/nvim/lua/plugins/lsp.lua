local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.diagnostic.config({
	severity_sort = true,
	underline = true,
	float = { border = "rounded", source = true },
	virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
})

vim.lsp.config("*", { capabilities = capabilities })

if vim.fn.executable("clangd") == 1 then
	vim.lsp.config("clangd", {
		cmd = {
			vim.fn.exepath("clangd"),
			"--query-driver=/nix/store/*/bin/clang++",
			"--background-index",
			"--clang-tidy",
		},
	})
	vim.lsp.enable("clangd")
end

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			completion = { callSnippet = "Replace" },
			diagnostics = { globals = { "vim" } },
		},
	},
})

vim.enabled = nil
vim.lsp.enable({ "nil_ls", "lua_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(ev)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "Goto definition")
		map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
		map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
		map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Prev diagnostic")
	end,
})
