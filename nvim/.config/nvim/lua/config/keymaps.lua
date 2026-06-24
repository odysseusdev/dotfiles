-- save file (works in normal, insert, visual)
vim.keymap.set({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "save file" })

-- clear search highlight with esc
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "clear highlight" })

-- move lines up/down (normal, insert, visual)
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-1<cr>==", { desc = "move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-1<cr>==gi", { desc = "move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move selection up" })

-- keep selection when indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "indent left (keep selection)" })
vim.keymap.set("v", ">", ">gv", { desc = "indent right (keep selection)" })

-- center the view after search jumps and half-page scrolls
vim.keymap.set("n", "n", "nzzzv", { desc = "next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "half page up (centered)" })

-- better up/down on wrapped lines (move by visual line)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- window splits (creating them; navigation is tmux-navigation's job)
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "split window below" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "split window right" })
vim.keymap.set("n", "<leader>wd", "<C-w>c", { desc = "delete window" })

-- buffer delete (S-h/S-l for navigation lives in bufferline.lua)
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "delete buffer" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "quit all" })

-- keep cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines (keep cursor)" })

-- paste over selection without losing the yank register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste (keep register)" })