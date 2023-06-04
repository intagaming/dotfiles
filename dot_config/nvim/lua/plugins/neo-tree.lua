return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

        require("neo-tree").setup({
            -- event_handlers = {
            --     {
            --         event = "file_opened",
            --         handler = function()
            --             --auto close
            --             require("neo-tree").close_all()
            --         end
            --     },
            -- },
            close_if_last_window = true,
            window = {
                position = "right",
            },
            filesystem = {
                follow_current_file = true,
            }
        })

        vim.keymap.set('n', '<leader>pv', ':Neotree reveal toggle<CR>', { noremap = true, silent = true })
    end
}
