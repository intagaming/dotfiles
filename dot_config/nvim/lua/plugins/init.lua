if vim.g.vscode then
    return {
        'tpope/vim-surround',
    }
else
    return {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua',
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
        'JoosepAlviste/nvim-ts-context-commentstring',
        'tpope/vim-surround',
        'tpope/vim-sleuth',
        { "nvim-tree/nvim-web-devicons", opts = {} },
        'windwp/nvim-ts-autotag',
        "b0o/schemastore.nvim",
    }
end
