return {
  "alexghergh/nvim-tmux-navigation",
  event = "VeryLazy",
  opts = {
    disable_when_zoomed = true, -- don't accidentally leave a zoomed tmux pane
  },
  keys = {
    { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", desc = "navigate left" },
    { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", desc = "navigate down" },
    { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", desc = "navigate up" },
    { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", desc = "navigate right" },
  },
}