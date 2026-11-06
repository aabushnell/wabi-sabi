local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.diagnostic.config({
	severity_sort = true,
	underline = true,
	float = { border = "rounded", source = true },
	virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
})

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

vim.lsp.config("*", { capabilities = capabilities })

local function enable_if(cmd, name, config)
	if vim.fn.executable(cmd) ~= 1 then
		return
	end
	if config then
		vim.lsp.config(name, config)
	end
	vim.lsp.enable(name)
end

--
-- always-on drivers
--

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			completion = { callSnippet = "Replace" },
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Nix & Lua
vim.lsp.enable({ "nil_ls", "lua_ls" })

--
-- dev-shell provided drivers
--

-- C/C++ (via clang-tools pkg)
enable_if("clangd", "clangd", {
	cmd = {
		vim.fn.exepath("clangd"),
		"--background-index",
		"--clang-tidy",
		"--query-driver=/nix/store/*/bin/gcc,/nix/store/*/bin/g++,/nix/store/*/bin/clang++,/nix/store/*-riscv64-none-elf-gcc-*/bin/riscv64-none-elf-gcc,**/musl_installation/bin/musl-gcc",
	},
})

-- Rust (via rust-analyzer pkg)
enable_if("rust-analyzer", "rust-analyzer")

-- Python (via pyright pkg)
enable_if("pyright-langserver", "pyright")

-- Java (via java-language-server pkg)
enable_if("java-language-server", "java_language_server")

-- Markdown (via marksman pkg)
enable_if("marksman", "marksman")
