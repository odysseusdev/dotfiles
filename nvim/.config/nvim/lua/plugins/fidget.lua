return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		notification = {
			override_vim_notify = true, -- route vim.notify through fidget's quiet corner
			window = {
				winblend = 0, -- no transparency artifacts
			},
		},
		progress = {
			display = {
				done_icon = "✓",
			},
		},
	},
}
