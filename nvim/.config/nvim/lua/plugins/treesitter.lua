return {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        sync_install = false,
        auto_install = true,
        ensure_installed = {
            'lua',
            'javascript',
            'typescript',
            'vimdoc',
            'vim',
            'regex',
            'sql',
            'dockerfile',
            'toml',
            'json',
            'go',
            'gitignore',
            'graphql',
            'yaml',
            'markdown',
            'markdown_inline',
            'bash',
            'tsx',
            'css',
            'html',
        },
    },
    ---@param opts TSConfig
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}

