vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
    event_handlers = {
        {
            event = "file_opened",
            handler = function()
                --auto close
                require("neo-tree").close_all()
            end
        },
    }
})

vim.keymap.set('n', '<leader>pv', ':Neotree reveal toggle<CR>', { noremap = true, silent = true })
