return {
	-- Temas
	{
		"ellisonleao/gruvbox.nvim",
		"nyoom-engineering/oxocarbon.nvim",
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
			},
		},
	},
}
