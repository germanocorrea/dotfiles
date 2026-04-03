
-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

vim.o.number = true -- Show line numbers in a column.

-- Show line numbers relative to where the cursor is.
-- Affects the 'number' option above, see `:h number_relativenumber`.
vim.o.relativenumber = false

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 5 -- Keep this many screen lines above/below the cursor.
vim.o.list = true -- Show <tab> and trailing spaces.

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- Source - https://stackoverflow.com/a/74584098
-- Posted by Brotify Force, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-04-03, License - CC BY-SA 4.0

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- Quickstart configs for LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Fuzzy picker
  'https://github.com/ibhagwan/fzf-lua',
  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  -- Tree Sitter
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- Highlight word under cursor
  'https://github.com/RRethy/vim-illuminate',
  -- indent lines
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  -- todo comments
  'https://github.com/folke/todo-comments.nvim',
  -- debug adapter protocol
  'https://github.com/mfussenegger/nvim-dap',
  -- diagnostics/errors
  'https://github.com/folke/trouble.nvim',
  -- bg transparency
  'https://github.com/xiyaowong/transparent.nvim',
  -- completion
  -- 'https://github.com/hrsh7th/nvim-cmp',
  -- jetbrains like info about references
  'https://github.com/VidocqH/lsp-lens.nvim',
  -- signature of method as you type
  'https://github.com/ray-x/lsp_signature.nvim',

  -- colorschemes
  'https://github.com/rose-pine/neovim',
  'https://github.com/nyoom-engineering/oxocarbon.nvim',
})

require('fzf-lua').setup { fzf_colors = true }
require('mini.completion').setup {}
require('quicker').setup {}
require('gitsigns').setup {}
require('nvim-treesitter').setup {}
require('illuminate').configure {}
require('ibl').setup {}
require('todo-comments').setup {}
require('dap')
require('trouble').setup {}
require('lsp-lens').setup {
	include_declaration = true,
	sections = {
		definition = true,
	},
}
require('rose-pine')

require('transparent').setup { -- Optional, you don't have to run setup.
    groups = {           -- table: default groups
	"Normal",
	"NormalNC",
	"Comment",
	"Constant",
	"Special",
	"Identifier",
	"Statement",
	"PreProc",
	"Type",
	"Underlined",
	"Todo",
	"String",
	"Function",
	"Conditional",
	"Repeat",
	"Operator",
	"Structure",
	"LineNr",
	"NonText",
	"SignColumn",
	"CursorLine",
	"CursorLineNr",
	"StatusLine",
	"StatusLineNC",
	"EndOfBuffer",
    },
    extra_groups = {"NeoTreeNormal","NeoTreeNormalNC"}, -- and this was super important as well
    exclude_groups = {}, -- table: groups you don't want to clear
}

require('nvim-treesitter').install { 'rust', 'javascript', 'typescript', 'php', 'zig', 'c', 'cpp', 'css', 'diff', 'dockerfile', 'awk', 'bash', 'cmake', 'csv', 'editorconfig', 'elixir', 'erlang', 'haskell', 'gomod', 'go', 'gnuplot', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'html', 'ini', 'java', 'json', 'json5', 'jsx', 'tsx', 'kotlin', 'latex', 'lua', 'luadoc', 'make', 'markdown', 'matlab', 'mermaid', 'nix', 'regex', 'ruby', 'scala', 'sql', 'ssh_config', 'terraform', 'vhdl', 'yaml', 'zsh', 'toml', 'arduino', 'clojure' }

vim.cmd("colorscheme oxocarbon")

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'javascript', 'typescript', 'php', 'zig', 'c', 'cpp', 'css', 'diff', 'dockerfile', 'awk', 'bash', 'cmake', 'csv', 'editorconfig', 'elixir', 'erlang', 'haskell', 'gomod', 'go', 'gnuplot', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'html', 'ini', 'java', 'json', 'json5', 'jsx', 'tsx', 'kotlin', 'latex', 'lua', 'luadoc', 'make', 'markdown', 'matlab', 'mermaid', 'nix', 'regex', 'ruby', 'scala', 'sql', 'ssh_config', 'terraform', 'vhdl', 'yaml', 'zsh', 'toml', 'arduino', 'clojure' },
  callback = function() vim.treesitter.start() end,
})

vim.lsp.enable('gopls')
vim.lsp.enable('bash-language-server')
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('phpactor')
vim.lsp.enable('typescript-language-server')
vim.lsp.enable('clangd')
vim.lsp.enable('hls')

vim.lsp.codelens.enable(true)
-- vim.lsp.completion.enable(true)
vim.lsp.linked_editing_range.enable(true)
vim.lsp.inlay_hint.enable(true)
vim.lsp.inline_completion.enable(true)

