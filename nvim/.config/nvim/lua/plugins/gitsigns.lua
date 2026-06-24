return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end
      map("n", "]h", gs.next_hunk, "next hunk")
      map("n", "[h", gs.prev_hunk, "previous hunk")
      map("n", "<leader>ghs", gs.stage_hunk, "stage hunk")
      map("n", "<leader>ghr", gs.reset_hunk, "reset hunk")
      map("n", "<leader>ghp", gs.preview_hunk, "preview hunk")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "blame line")
      map("n", "<leader>ghd", gs.diffthis, "diff this")
    end,
  },
}