return {
    'jose-elias-alvarez/null-ls.nvim',
    cond = not vim.g.vscode,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.nixpkgs_fmt,
                null_ls.builtins.formatting.sql_formatter,
            },
            debug = true,
        })
    end
}
