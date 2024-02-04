return {
    'mbbill/undotree',
    cond = not vim.g.vscode,
    keys = {
        { '<leader>u', '<cmd>UndotreeToggle<CR>' }
    }
}
