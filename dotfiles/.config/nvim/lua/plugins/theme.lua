return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        opts = {
            highlight_groups = {
                Comment = { italic = true },
            },
            disable_italics = true, -- Désactivation des italiques si pris en charge
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
        end,
    },

    { "Mofiqul/dracula.nvim" },
    { "sainnhe/sonokai" },
    { "folke/tokyonight.nvim" },
    { "Pocco81/Catppuccino.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { "olivercederborg/poimandres.nvim" },
    { "scottmckendry/cyberdream.nvim" },
    { "olimorris/onedarkpro.nvim" },
    { "tiagovla/tokyodark.nvim" },
    { "maxmx03/fluoromachine.nvim" },
    { "ray-x/aurora" },
    { "EdenEast/nightfox.nvim" },
    { "cocopon/iceberg.vim" },

    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "catppuccin-mocha",
            colorscheme = "tokyonight-night",
            -- colorscheme = "rose-pine",
            -- colorscheme = "dracula",
            -- colorscheme = "sonokai",
        },
    },
}
