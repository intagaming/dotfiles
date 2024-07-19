local lsp_attach = require "an7/lsp_attach"
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()

return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    cond = not vim.g.vscode,
    opts = {
        init_options = {
            preferences = {
                importModuleSpecifierPreference = "non-relative",
            }
        },
        on_attach = function(client, bufnr)
            lsp_attach(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
        end,
        capabilities = lsp_capabilities,
    },
    config = function()
        vim.keymap.set("n", "<leader>trf", function() vim.cmd [[TSToolsRenameFile]] end)
        vim.keymap.set("n", "<leader>ti", function() vim.cmd [[TSToolsAddMissingImports]] end)
        vim.keymap.set("n", "<leader>tu", function() vim.cmd [[TSToolsRemoveUnusedImports]] end)
    end,
}
