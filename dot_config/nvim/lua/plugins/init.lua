return {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',

    'JoosepAlviste/nvim-ts-context-commentstring',

    'tpope/vim-surround',

    'nvim-treesitter/nvim-treesitter-context',

    'tpope/vim-sleuth',

    'nvim-tree/nvim-web-devicons',

    'windwp/nvim-ts-autotag',

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        init = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    },

    "b0o/schemastore.nvim",

}
