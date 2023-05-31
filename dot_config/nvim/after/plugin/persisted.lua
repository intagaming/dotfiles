require("persisted").setup({
    autoload = true
})

local group = vim.api.nvim_create_augroup("PersistedHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "PersistedSavePre",
  group = group,
  callback = function()
    require 'neo-tree.sources.manager'.close_all()
    vim.notify('closed all')
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "PersistedLoadPost",
  group = group,
  callback = function()
    vim.notify('opening neotree')
    require 'neo-tree.sources.manager'.show('filesystem')
  end,
})
