return {
    'jose-elias-alvarez/null-ls.nvim',
    cond = not vim.g.vscode,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettierd
            },
            debug = true,
        })
    end
}
