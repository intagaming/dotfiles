vim.g.skip_ts_context_commentstring_module = true

if vim.g.vscode then
else
    require("an7.remap")
end

require("an7.lazy")
require("an7.set")
