return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "toggle explorer" },
		{ "<leader>eg", "<cmd>Neotree git_status<cr>", desc = "git explorer" },
		{ "<leader>eb", "<cmd>Neotree buffers<cr>", desc = "buffer explorer" },
	},
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false,
				hide_dotfiles = false,
				hide_gitignored = false, -- toggle with H
			},
		},
		window = {
			width = 32,
			mappings = {
				["<space>"] = "none",
				["P"] = { "toggle_preview", config = { use_float = true } },
				["l"] = "open",
				["h"] = "close_node",
				["H"] = "toggle_hidden",
			},
		},
		default_component_configs = {
			indent = { with_expanders = true },
			git_status = {
				symbols = {
					added = "",
					modified = "",
					deleted = "✖",
					renamed = "󰁕",
					untracked = "",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
				},
			},
		},
	},
}
