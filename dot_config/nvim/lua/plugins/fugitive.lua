return {
    'tpope/vim-fugitive',
    cond = not vim.g.vscode,
    setup = {
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
    }
}
