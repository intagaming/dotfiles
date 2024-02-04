return {
    "lukas-reineke/indent-blankline.nvim",
    cond = not vim.g.vscode,
    main = "ibl",
    opts = {},
    config = function()
        vim.opt.list = true
        vim.opt.listchars:append "space:⋅"
        require("ibl").setup({
            scope = {
                show_start = false,
            }
        })
    end
}
