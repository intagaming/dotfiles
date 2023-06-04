return {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local trouble = require("trouble.providers.telescope")
        local telescope = require("telescope")
        telescope.setup {
            defaults = {
                mappings = {
                    i = { ["<c-t>"] = trouble.open_with_trouble },
                    n = { ["<c-t>"] = trouble.open_with_trouble },
                },
            },
        }
    end,
    keys = {
        { "<leader>xx", "<cmd>TroubleToggle<cr>", silent = true, noremap = true },
        {
            "<leader>xw",
            "<cmd>TroubleToggle workspace_diagnostics<cr>",
            silent = true,
            noremap = true
        },
        {
            "<leader>xd",
            "<cmd>TroubleToggle document_diagnostics<cr>",
            silent = true,
            noremap = true
        },
        {
            "<leader>xl",
            "<cmd>TroubleToggle loclist<cr>",
            silent = true,
            noremap = true
        },
        {
            "<leader>xq",
            "<cmd>TroubleToggle quickfix<cr>",
            silent = true,
            noremap = true
        },
        {
            "gR",
            "<cmd>TroubleToggle lsp_references<cr>",
            silent = true,
            noremap = true
        }
    },
}
