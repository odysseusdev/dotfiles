local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- add lazy.nvim to the runtime path so `require("lazy")` works
vim.opt.rtp:prepend(lazypath)

-- leader keys must be set before lazy loads (plugins bake them in on load)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- load global editor options before plugins
require("config.options")

-- set up lazy.nvim and load every plugin spec under lua/plugins/
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	defaults = {
		lazy = false, -- custom plugins load on startup unless their spec says otherwise
		version = false, -- track latest git commit, not (often stale) tagged releases
	},
	install = { colorscheme = { "catppuccin" } }, -- theme shown during first-run install
	checker = { enabled = true, notify = false }, -- check for updates silently
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})

-- load global keymaps and autocmds after plugins, so they can reference plugin state
require("config.keymaps")
require("config.autocmds")
