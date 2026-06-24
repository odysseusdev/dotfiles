-- line numbers
vim.opt.number = true -- absolute number on the cursor line
vim.opt.relativenumber = true -- relative numbers elsewhere

-- indentation
vim.opt.expandtab = true -- tabs become spaces
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.tabstop = 2 -- a tab renders as 2 spaces
vim.opt.smartindent = true -- auto-indent new lines sensibly

-- search
vim.opt.ignorecase = true -- case-insensitive search when entire string is lowercase
vim.opt.smartcase = true -- case-sensitive search when string includes a capital letter
vim.opt.hlsearch = true -- highlight matches

-- ui
vim.opt.termguicolors = true -- 24-bit colour
vim.opt.signcolumn = "yes" -- always show the sign column so text doesn't jump
vim.opt.cursorline = true -- highlight the current line
vim.opt.wrap = false -- no line wrapping
vim.opt.scrolloff = 8 -- keep 8 lines visible above/below the cursor
vim.opt.sidescrolloff = 8 -- keep 8 lines visible left/right of the cursor

-- splits
vim.opt.splitright = true -- vertical splits open to the right
vim.opt.splitbelow = true -- horizontal splits open below

-- files & undo
vim.opt.undofile = true -- persistent undo across sessions
vim.opt.swapfile = false -- no swap files
vim.opt.autoread = true -- re-read files changed outside nvim (when triggered)

-- behaviour
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.updatetime = 200 -- faster CursorHold events
vim.opt.timeoutlen = 500 -- which-key popup delay
