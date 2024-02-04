return {
    'folke/zen-mode.nvim',
    cond = not vim.g.vscode,
    keys = {
        { '<leader>zz', function()
            require("zen-mode").setup {
                window = {
                    width = 90,
                    options = {}
                },
            }
            require("zen-mode").toggle()
            vim.wo.number = true
            vim.wo.rnu = true
        end }
    }
}
