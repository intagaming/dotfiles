return {
    "vuki656/package-info.nvim",
    cond = not vim.g.vscode,
    dependencies = "MunifTanjim/nui.nvim",
    config = {},
    keys = {
        { "<LEADER>ns", require("package-info").show,   silent = true, noremap = true },
        { "<LEADER>nh", require("package-info").hide,   silent = true, noremap = true },
        { "<LEADER>nt", require("package-info").toggle, silent = true, noremap = true },
        { "<LEADER>nu", require("package-info").update, silent = true, noremap = true },
    },
}
