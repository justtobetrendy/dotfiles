return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
        require("catppuccin").setup({
            styles = {
                comments = { "bold" },
                properties = { "bold" },
                functions = { "bold" },
                keywords = {},
                operators = { "bold" },
                conditionals = {},
                loops = {},
                booleans = { "bold", },
                numbers = {},
                types = {},
                strings = {},
                variables = {},
            },
            integrations = {
                cmp = true,
                flash = true,
                fzf = true,
                gitsigns = true,
                indent_blankline = { enabled = true },
                lsp_trouble = true,
                mason = true,
                markdown = true,
                native_lsp = {
                    enabled = true,
                    -- virtual_text = {
                    --     errors = { "italic" },
                    --     hints = { "italic" },
                    --     warnings = { "italic" },
                    --     information = { "italic" },
                    --     ok = { "italic" },
                    -- },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                neotree = true,
                -- noice = true,
                -- notify = true,
                render_markdown = true,
                snacks = {
                    enabled = false,
                    indent_scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
                },
                telescope = {
                    enabled = true,
                },
                treesitter = true,
                treesitter_context = true,
                which_key = true,
            },
        })

        vim.cmd.colorscheme "catppuccin-macchiato"
        -- vim.cmd.colorscheme "catppuccin"

        -- Explicitly set diagnostic underline styles
        vim.cmd([[
            highlight DiagnosticUnderlineError gui=undercurl
            highlight DiagnosticUnderlineWarn gui=undercurl
            highlight DiagnosticUnderlineInfo gui=undercurl
            highlight DiagnosticUnderlineHint gui=undercurl
        ]])
    end
}
