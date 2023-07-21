return {
    'tpope/vim-fugitive',
    setup = {
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
    }
}
