return {
	"famiu/bufdelete.nvim",
	keys = {
		{
			"<leader>bd",
			function()
				require("bufdelete").bufdelete(0)
			end,
			desc = "delete buffer",
		},
		{
			"<leader>bD",
			function()
				require("bufdelete").bufdelete(0, true)
			end,
			desc = "delete buffer (force)",
		},
	},
}
