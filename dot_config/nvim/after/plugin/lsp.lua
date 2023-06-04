local cmp = require('cmp')
local lsp_zero_formatter = function(entry, item)
    local short_name = {
        nvim_lsp = 'LSP',
        nvim_lua = 'nvim'
    }

    local menu_name = short_name[entry.source.name] or entry.source.name

    item.menu = string.format('[%s]', menu_name)
    return item
end
local tailwind_color = function(entry, vim_item) -- for tailwind css autocomplete
    if vim_item.kind == 'Color' and entry.completion_item.documentation then
        local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
        if r then
            local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
            local group = 'Tw_' .. color
            if vim.fn.hlID(group) < 1 then
                vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
            end
            vim_item.kind = "■" -- or "⬤" or anything
            vim_item.kind_hl_group = group
            return vim_item
        end
    end
    -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
    -- or just show the icon
    -- vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
    return vim_item
end

local luasnip = require("luasnip")
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    formatting = {
        format = function(entry, item)
            lsp_zero_formatter(entry, item)
            tailwind_color(entry, item)
            return item
        end,
    }
})

require("luasnip.loaders.from_vscode").lazy_load()


require('mason').setup()
require('mason-lspconfig').setup({})

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = (function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

local util = require 'lspconfig.util'
local astro_path = util.path.join(vim.fn.stdpath 'data', 'mason', 'packages', 'astro-language-server', 'node_modules')
local global_ts = util.path.join(astro_path, 'typescript', 'lib')
--
-- local function get_typescript_lib_path(root_dir)
--     local project_root = util.find_node_modules_ancestor(root_dir)
--     return project_root and (path.join(project_root, 'node_modules', 'typescript', 'lib'))
--         or global_ts_server_path
-- end
local function get_typescript_server_path(root_dir)
    local found_ts = ''
    local function check_dir(path)
        found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib')
        if util.path.exists(found_ts) then
            return path
        end
    end
    if util.search_ancestors(root_dir, check_dir) then
        return found_ts
    else
        return global_ts
    end
end

require('mason-lspconfig').setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
        })
    end,

    ["tailwindcss"] = function()
        lspconfig.tailwindcss.setup({
            on_attach = function(client, bufnr)
                lsp_attach(client, bufnr)
                vim.opt.wrap = true
            end,
            capabilities = lsp_capabilities,
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
    end,

    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
    end,

    ["jsonls"] = function()
        lspconfig.jsonls.setup {
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        }
    end,

    ["tsserver"] = function()
        require("typescript").setup({
            server = {
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
            }
        })
    end,

    ["eslint"] = function()
        lspconfig.eslint.setup {
            on_attach = function(client, bufnr)
                lsp_attach(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>e", "<cmd>EslintFixAll<CR>", opts)
            end,
            capabilities = lsp_capabilities,
        }
    end,

    ["astro"] = function()
        lspconfig.astro.setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            on_new_config = function(new_config, new_root_dir)
                new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
            end,
        })
    end,
})

vim.opt.signcolumn = 'yes'
vim.diagnostic.config({
    virtual_text = true
})
