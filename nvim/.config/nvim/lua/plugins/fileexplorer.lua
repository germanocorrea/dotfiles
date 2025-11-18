return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      disable_netrw = true,
      hijack_netrw = true,
      -- open_on_setup = false,
      filters = {
        dotfiles = false,
        exclude = {},
      },
      view = {
        width = 30,
        -- auto_resize = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
  end,
}
