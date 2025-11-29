local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- 1. Carrega o LazyVim e seus plugins core
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			-- Aplica seu override de colorscheme AQUI
			opts = {
				colorscheme = "oxocarbon",
			},
		},

		-- 2. Carrega os EXTRAS (movidos do seu arquivo de plugins)
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		--{ import = "lazyvim.plugins.extras.ui.mini-starter" },
		{ import = "lazyvim.plugins.extras.lang.json" },

		-- 3. Carrega seus plugins customizados (de lua/plugins/) DEPOIS de todo o resto
		{ import = "plugins" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = {
		enabled = true,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
