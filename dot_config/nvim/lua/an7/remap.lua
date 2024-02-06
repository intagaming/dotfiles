vim.g.mapleader = " "

if vim.g.vscode then

else
    vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")

    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

    vim.keymap.set("n", "J", "mzJ`z")
    vim.keymap.set("n", "<C-d>", "<C-d>zz")
    vim.keymap.set("n", "<C-u>", "<C-u>zz")
    vim.keymap.set("n", "n", "nzzzv")
    vim.keymap.set("n", "N", "Nzzzv")

    vim.keymap.set("x", "<leader>p", [["_dP]])

    vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

    vim.keymap.set("i", "<C-c>", "<Esc>")

    vim.keymap.set("n", "Q", "<nop>")

    vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>zz")
    vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>zz")
    vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
    vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

    vim.keymap.set("n", "<M-z>", "<cmd>:set wrap!<CR>")
end

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
