return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		-- diagnostics
		vim.diagnostic.config({
			virtual_text = { prefix = "●", source = "if_many" },
			severity_sort = true,
			float = { border = "rounded", source = true },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		-- per-buffer keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local map = function(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
				end
				map("gd", vim.lsp.buf.definition, "goto definition")
				map("gr", vim.lsp.buf.references, "references")
				map("gI", vim.lsp.buf.implementation, "goto implementation")
				map("gy", vim.lsp.buf.type_definition, "goto type definition")
				map("gD", vim.lsp.buf.declaration, "goto declaration")
				map("K", vim.lsp.buf.hover, "hover docs")
				map("<leader>ca", vim.lsp.buf.code_action, "code action")
				map("<leader>cr", vim.lsp.buf.rename, "rename")
				map("<leader>cl", "<cmd>LspInfo<cr>", "lsp info")
				map("<leader>uh", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end, "toggle inlay hints")

				-- tailwind/css colour hints as a small inline swatch, not a background fill
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.name == "tailwindcss" then
					vim.lsp.document_color.enable(true, { bufnr = ev.buf }, { style = "● " })
				end
			end,
		})

		-- capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- server definitions
		local servers = {
			-- web
			vtsls = {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
						},
					},
					javascript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							variableTypes = { enabled = true },
						},
					},
				},
			},
			svelte = {},
			html = {},
			cssls = {},
			tailwindcss = {
				settings = {
					tailwindCSS = {
						classFunctions = { "cva", "cx", "clsx", "cn", "tw", "twMerge" },
					},
				},
			},
			emmet_language_server = {},
			-- data / config
			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
			yamlls = {
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" }, -- disable built-in, use the plugin
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},
			-- lua
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						completion = { callSnippet = "Replace" },
						hint = { enable = true },
						diagnostics = { globals = { "vim" } },
					},
				},
			},
		}

		-- install
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			handlers = {
				function(server_name)
					local server_opts = servers[server_name] or {}
					server_opts.capabilities =
						vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
					require("lspconfig")[server_name].setup(server_opts)
				end,
			},
		})
	end,
}
