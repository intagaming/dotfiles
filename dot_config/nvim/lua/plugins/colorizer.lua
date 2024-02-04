return {
    'NvChad/nvim-colorizer.lua',
    cond = not vim.g.vscode,
    config = {
        user_default_options = {
            tailwind = "lsp"
        }
    }
}
