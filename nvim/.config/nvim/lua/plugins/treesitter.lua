-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",	-- required for nvim 0.12.x
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    local ensure_installed = {
			"lua", "vim", "vimdoc", "query",                  -- neovim itself
			"javascript", "typescript", "tsx",                -- ts/js + react
			"svelte",                                         -- svelte
			"html", "css", "scss",                            -- markup & styles
			"json", "jsonc", "yaml", "toml", "dockerfile",    -- config/data formats
			"c_sharp",                                        -- c# / asp.net
			"sql",                                            -- databases
			"markdown", "markdown_inline",                    -- docs
			"bash", "regex", "gitignore",				              -- misc
    }

    -- install only the parsers not already present (install() is a no-op otherwise)
    local installed = require("nvim-treesitter.config").get_installed()
    local to_install = vim.tbl_filter(function(p)
      return not vim.tbl_contains(installed, p)
    end, ensure_installed)
    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    -- the rewrite no longer auto-enables features; we turn them on per-filetype
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)  -- highlighting (neovim core)
        -- treesitter-based indentation (plugin-provided, still experimental)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}