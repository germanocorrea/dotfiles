return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and Mason clients
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Autocompletion
        "hrsh7th/nvim-cmp",     -- Required
        "hrsh7th/cmp-nvim-lsp", -- Required
        "L3MON4D3/LuaSnip",     -- Required
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        -- Set up mason
        require("mason").setup()

        -- Set up mason-tool-installer to automatically install formatters and linters
        require("mason-tool-installer").setup({
            ensure_installed = {
                -- General
                "editorconfig-checker",
                -- "prettier",      -- For JS/TS/HTML/CSS formatting
                "stylua",        -- For Lua formatting
                "black",         -- For Python formatting
                "isort",         -- For Python imports sorting
                "shfmt",         -- For Shell Script formatting
                -- "sql-formatter", -- For SQL formatting
                -- "rustywind",     -- For Tailwind CSS class sorting (useful with JS/TS frameworks)
                "goimports",     -- For Go imports
                "gofumpt",       -- For Go formatting

                -- Linters
                "flake8",       -- Python linter
                -- "golangci-linter", -- Go linter
                "shellcheck",   -- Shell script linter
                "hadolint",     -- Dockerfile linter
                -- "markdownlint", -- Markdown linter

                -- Debuggers (DAP)
                "codelldb",       -- For C/C++/Rust/Go
                -- "python-debugpy", -- For Python
                "delve",          -- For Go
                -- "xdebug",         -- For PHP
            },
        })

        -- Set up mason-lspconfig to automatically install LSP servers
        require("mason-lspconfig").setup({
            ensure_installed = {
                -- C/C++
                "clangd",
                "csharp_ls",

                -- Rust
                "rust_analyzer",

                -- Go
                "gopls",

                -- PHP
                "phpactor",
                -- "intelephense", -- Alternative/complementary for PHP (paid features)

                -- Python
                -- "pyright",
                "ruff", -- Alternative/complementary for Python (fast linter/formatter)

                -- Haskell
                -- "hls",

                -- Javascript/Typescript
                -- "ts_ls",
                "denols", -- If using Deno
                -- "biome",  -- New all-in-one tool for JS/TS (linter, formatter, LSP)

                -- SQL
                -- "sqlls",

                -- Shell Script
                -- "bashls",

                -- Neovim Lua development
                "lua_ls",
            },
        })

        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            }),
        })

        -- Configure LSP servers
        local lspconfig = require("lspconfig")

        -- C/C++
        lspconfig.clangd.setup({})

        -- Rust
        lspconfig.rust_analyzer.setup({
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        loadOutDirsFromEnv = true,
                    },
                    procMacro = {
                        enable = true,
                    },
                },
            },
        })

        -- Go
        lspconfig.gopls.setup({})

        -- PHP
        lspconfig.phpactor.setup({})
        -- lspconfig.intelephense.setup({}) -- If you decide to use intelephense

        -- Python
        lspconfig.pyright.setup({})
        lspconfig.ruff.setup({})

        -- Haskell
        lspconfig.hls.setup({})

        -- Javascript/Typescript
        lspconfig.ts_ls.setup({})
        lspconfig.biome.setup({}) -- If you decide to use biome

        -- SQL
        lspconfig.sqlls.setup({})

        -- Shell Script
        lspconfig.bashls.setup({})

        -- Lua
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    workspace = {
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
    end,
}
