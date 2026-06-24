return {
	"mason-org/mason.nvim",
	cmd = "Mason",
	keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "mason" } },
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {
			-- formatters & linters (language servers are handled in lspconfig.lua)
			"stylua", -- lua formatter
			"prettierd", -- fast prettier daemon for js/ts/svelte/css/json
			"eslint_d", -- fast eslint daemon
			"csharpier", -- c# formatter
			"sql-formatter", -- sql formatter
		},
		ui = {
			border = "rounded",
			icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)
		-- mason doesn't auto-install ensure_installed by itself; this loop does it.
		local mr = require("mason-registry")
		mr.refresh(function()
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end)
	end,
}
