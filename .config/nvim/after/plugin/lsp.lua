local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})



local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<Tab>'] = vim.NIL,
    ['<S-Tab>'] = vim.NIL,
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
})

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

vim.opt.signcolumn = 'yes'

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require("typescript").setup({
    server = {
        init_options = {
            preferences = {
                importModuleSpecifierPreference = "non-relative",
            }
        },
        on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
        end,
    }
})

require('lspconfig').tailwindcss.setup({
    settings = {
        tailwindCSS = {
            experimental = {
                classRegex = {
                    { "cva\\(([^)]*)\\)",
                        "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "class:list=\\{([^}]*)\\}",
                        "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
            },
        },
    },
})

require('lspconfig').jsonls.setup {
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
