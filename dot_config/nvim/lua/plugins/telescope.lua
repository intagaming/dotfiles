return {
    'nvim-telescope/telescope.nvim',
    cond = not vim.g.vscode,
    branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    keys = {
        { '<leader>pf', function()
            require('telescope.builtin').find_files()
        end },
        { '<leader>ps', function()
            local text = vim.fn.input("Grep > ")
            if text == "" then return end
            require('telescope.builtin').grep_string({ search = text });
        end },
        { '<leader>pls', function()
            require('telescope.builtin').live_grep()
        end },
    },
    opts = {
        defaults = {
            path_display = {
                "smart"
            },
        },
    },
}
