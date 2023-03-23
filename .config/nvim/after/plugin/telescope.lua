local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function()
	builtin.find_files({ hidden = true })
end)
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	local text = vim.fn.input("Grep > ")
	if text == "" then return end
	builtin.grep_string({ search = text });
end)
