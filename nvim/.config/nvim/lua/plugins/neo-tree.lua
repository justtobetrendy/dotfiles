return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup()

        vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", { noremap = true, silent = true }) -- focus file explorer
        -- vim.keymap.set("n", "<leader>ngs", ":Neotree float git_status<CR>", { noremap = true, silent = true }) -- open git status window

        -- reveal current buffer file when hitting \
        vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    end
}
