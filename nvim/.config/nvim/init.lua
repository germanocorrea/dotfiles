-- bootstrap lazy.nvim, LazyVim and your plugins
vim.cmd("source " .. vim.fn.expand("./colors/colors-wal.vim"))
require("config.lazy")
