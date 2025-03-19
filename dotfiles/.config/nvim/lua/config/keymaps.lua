-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- local Util = require("lazyvim.util")

vim.keymap.set("n", "<F1>", function()
    vim.lsp.buf.hover()
end, { desc = "Show function signature" })
vim.keymap.set("n", "<F2>", "<Leader>cr", { remap = true, desc = "Rename symbol" })
-- vim.keymap.set("n", "<F1>", "<Leader>cr", { silent = true })
vim.keymap.set("n", "<F5>", ":FzfLua lsp_workspace_diagnostics<cr>", { silent = true })
vim.keymap.set("n", "<F9>", ":FzfLua lsp_references<cr>", { silent = true })
vim.keymap.set("n", "<F10>", ":FzfLua lsp_document_symbols<cr>", { silent = true })
vim.keymap.set("n", "<F12>", ":FzfLua lsp_definitions<cr>", { silent = true })

-- C-q override the default keymap (block selection)
vim.keymap.set("n", "<C-q>", "<Cmd>:q<cr>", { silent = true })
vim.keymap.set("n", "<C-x>", "<Cmd>:bd<cr>", { silent = true })
vim.keymap.set("n", "<C-s>", "<Cmd>:w<cr>", { silent = true })

vim.keymap.set("n", "<C-b>", ":FzfLua buffers<cr>", { silent = true })
vim.keymap.set("n", "<C-p>", ":FzfLua files<cr>", { silent = true })
vim.keymap.set("n", "<C-g>", ":FzfLua grep_visual<CR>", { silent = true })

vim.keymap.set("n", "<C-Right>", "W", { silent = true })
vim.keymap.set("n", "<C-Left>", "B", { silent = true })
vim.keymap.set("n", "<C-PageUp>", ":bprev<cr>", { silent = true })
vim.keymap.set("n", "<C-PageDown>", ":bnext<cr>", { silent = true })

-- C-d => comment line
vim.api.nvim_set_keymap("n", "<C-d>", "gcc", { silent = true })
vim.api.nvim_set_keymap("v", "<C-d>", "gc", { silent = true })

-- C-f override the default keymap => fold-unfold
vim.keymap.set("n", "<C-f>", "za", { noremap = true, silent = true })

-- C-v => paste from clipboard in insert mode
vim.keymap.set("i", "<C-v>", "<C-r><C-r>+", { noremap = true, silent = true })

-- Ctl +/- for zomm in neovide
vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")

-- Aerial
vim.keymap.set("n", "<Leader>a", ":AerialToggle<CR>", { silent = true })

-- Old telescope keymaps
-- vim.keymap.set("n", "<F9>", "<Cmd>lua require('telescope.builtin').lsp_references()<cr>", { silent = true })
-- vim.keymap.set("n", "<F12>", "<Cmd>lua require('telescope.builtin').lsp_definitions()<cr>", { silent = true })
-- vim.keymap.set("n", "<C-b>", ":Telescope buffers<cr>", { silent = true })
-- vim.keymap.set("n", "<C-p>", ":Telescope find_files<cr>", { silent = true })
-- vim.keymap.set("n", "<C-g>", ":Telescope live_grep<CR>", { silent = true })
