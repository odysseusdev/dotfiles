return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "previous buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "pin buffer" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "close unpinned buffers" },
  },
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",       -- show LSP error/warn counts on tabs
      always_show_bufferline = false, -- hide when only one buffer is open
      offsets = {
        { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" },
      },
    },
  },
}