return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- load before all other plugins
	lazy = false, -- load at startup, not on-demand
	opts = {
		flavour = "macchiato",
		transparent_background = false,
		integrations = {
			-- tell catppuccin to theme these plugins to match
			alpha = true,
			treesitter = true,
			telescope = true,
			neotree = true,
			which_key = true,
			gitsigns = true,
			mason = true,
			fidget = true,
			blink_cmp = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
			},
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}
