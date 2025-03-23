return {
    'stevearc/conform.nvim',

    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                golang = { "gofmt" }, -- golines is another option
                go = { "gofmt" },     -- golines is another option
                yaml = { "prettier" },
                markdown = { "prettier" },
                -- toml = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 2500,
            },
        });

        vim.keymap.set({ "n", "v" }, "<leader>cF", vim.lsp.buf.format, { desc = "[c]ode [f]ormat" })
        -- vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        --     conform.format({
        --         lsp_fallback = true,
        --         async = false,
        --         timeout_ms = 1000,
        --     })
        -- end, { desc = "Format file or range (in visual mode)" })
    end
}
