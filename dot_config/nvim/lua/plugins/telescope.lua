return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    keys = {
        { '<leader>pf', function()
            require('telescope.builtin').find_files({ hidden = true })
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
}
