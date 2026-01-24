return {
	-- Temas
	{
		"ellisonleao/gruvbox.nvim",
		"nyoom-engineering/oxocarbon.nvim",
		"thesimonho/kanagawa-paper.nvim",
		"savq/melange-nvim",
		"vague-theme/vague.nvim",
		"craftzdog/solarized-osaka.nvim",
		{ "rose-pine/neovim", name = "rose-pine" },
	},

	{
		"scottmckendry/cyberdream.nvim",
		transparent_background = true,
		saturation = 0.7,
	},

	{
		"RedsXDD/neopywal.nvim",
		name = "neopywal",
		lazy = false,
		priority = 1000,
		opts = {
			transparent_background = true,
		},
	},

	-- Trouble
	{
		"folke/trouble.nvim",
		opts = { use_diagnostic_signs = true },
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
		},
	},

	-- ===================================================================
	-- CORREÇÃO DO LSP (HLS E PYRIGHT)
	-- ===================================================================

	{
		"mason-org/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"hls",
				"pyright",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {},
				hls = {
					settings = {
						haskell = {
							hlintOn = true,
						},
					},
				},
				phpactor = {},
			},
		},
	},
	-- ===================================================================

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"haskell",
				"go",
				"php",
				"zig",
				"c",
				"cpp",
				"cmake",
			})
		end,
	},

	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.sections.lualine_x, {
				function()
					return "😄"
				end,
			})
		end,
	},

	-- Mason
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
				"haskell-language-server",
				"hlint",
				"phpcs",
				"php-cs-fixer",
			},
		},
	},
}
