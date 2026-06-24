return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = { use_diagnostic_signs = true },
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics (trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics" },
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "symbols (trouble)" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "location list" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "quickfix list" },
	},
}
