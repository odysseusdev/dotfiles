return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true, -- jump forward to the textobj, like targets.vim
        selection_modes = {
          ["@function.outer"] = "V", -- linewise for functions
          ["@class.outer"] = "V",
        },
        include_surrounding_whitespace = false,
      },
      move = { set_jumps = true }, -- record jumps so C-o / C-i work
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local map = vim.keymap.set

    -- selection text objects (operator + visual)
    map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "a function" })
    map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "inner function" })
    map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "a class" })
    map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "inner class" })
    map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, { desc = "a parameter" })
    map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, { desc = "inner parameter" })

    -- movement between functions/classes
    map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "next function start" })
    map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "previous function start" })
    map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "next class start" })
    map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "previous class start" })
  end,
}