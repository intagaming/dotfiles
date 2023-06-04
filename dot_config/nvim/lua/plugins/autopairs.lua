return {
    'windwp/nvim-autopairs',
    config = function()
        require("nvim-autopairs").setup {}

        -- Who designs an API that needs to know the defaults to add a thing?
        local defaultFiletypes = {
            'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
            'rescript',
            'xml',
            'php',
            'markdown',
            'glimmer', 'handlebars', 'hbs'
        }

        local filetypes = defaultFiletypes
        table.insert(filetypes, 'astro')

        require('nvim-ts-autotag').setup {
            filetypes = filetypes
        }

        -- Insert `(` after autocomplete function and method item
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
}
