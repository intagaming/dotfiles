require("telescope").setup {
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      layout_config = {
        prompt_position = "top",
      },
      sorting_strategy = "ascending"
    },
  },
}
require("telescope").load_extension "file_browser"

vim.api.nvim_set_keymap(
  "n",
  "<leader>pv",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)
