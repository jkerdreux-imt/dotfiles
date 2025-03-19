-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
-- vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
-- vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.timeoutlen = 500

vim.opt.number = false -- Désactive les numéros de ligne
vim.opt.relativenumber = false -- Désactive les numéros relatifs

-- Neovide
-- vim.o.guifont = "FiraCode Nerd Font:h11:#e-subpixelantialias"
-- vim.o.guifont = "Noto Sans Mono:h11:#e-subpixelantialias"

vim.o.guifont = "VictorMono Nerd Font Mono:h12:#e-subpixelantialias"

vim.g.neovide_cursor_vfx_mode = "railgun"

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.b.autoformat = false -- Désactive l'autoformat pour ce buffer
    end,
})
