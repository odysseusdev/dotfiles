return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		-- file pickers
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "recent files" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "buffers" },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "git files" },
		-- search pickers
		{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "grep (project)" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "search word under cursor" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "help pages" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "keymaps" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "diagnostics" },
		{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "resume last picker" },
		{ "<leader>sc", "<cmd>Telescope commands<cr>", desc = "commands" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "search buffer" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = "  ",
				selection_caret = " ",
				path_display = { "truncate" },
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = { prompt_position = "top", preview_width = 0.55 },
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<esc>"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
