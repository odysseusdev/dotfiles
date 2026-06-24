return {
	-- types & completion for the neovim API and plugin modules
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	-- add lazydev as a blink source for lua files
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
				providers = {
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
		},
	},
}
