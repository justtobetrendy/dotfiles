return {
    {
        "williamboman/mason.nvim",

        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",

        config = function()
            require("mason-lspconfig").setup({
                -- add language servers here
                -- also update config/lsp.lua
                ensure_installed = {
                    "cssls",
                    "denols",
                    "dockerls",
                    "eslint",
                    "gopls",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "sqlls",
                    "tailwindcss",
                    -- "ts_ls",
                    "yamlls",
                    -- "csharp_ls",
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- add lsp for vim global in lua files.
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    }
    -- {
    --     "neovim/nvim-lspconfig",
    --     dependencies = {},
    --
    --     config = function()
    --         local capabilities = require('cmp_nvim_lsp').default_capabilities()
    --         local lspconfig = require("lspconfig")
    --
    --         -- disable inline diagnostic...
    --         vim.diagnostic.config({ virtual_text = false })
    --
    --         -- configure language servers here
    --         -- lspconfig.biome.setup({
    --         --     capabilities = capabilities,
    --         -- })
    --         lspconfig.cssls.setup({
    --             capabilities = capabilities
    --         })
    --         lspconfig.dockerls.setup({
    --             capabilities = capabilities
    --         })
    --         lspconfig.eslint.setup({
    --             capabilities = capabilities,
    --             flags = {
    --                 allow_incremental_sync = false,
    --                 debounce_text_changes = 1000,
    --             },
    --             on_attach = function(client)
    --                 client.server_capabilities.documentFormattingProvider = true
    --             end,
    --         })
    --         lspconfig.gopls.setup({
    --             capabilities = capabilities
    --         });
    --         lspconfig.html.setup({
    --             capabilities = capabilities,
    --             filetypes = { "html", "twig", "hbs" }
    --         })
    --         lspconfig.jsonls.setup({
    --             capabilities = capabilities,
    --         })
    --         lspconfig.lua_ls.setup({
    --             capabilities = capabilities,
    --         })
    --         lspconfig.sqlls.setup({
    --             capabilities = capabilities,
    --         })
    --         lspconfig.tailwindcss.setup({
    --             capabilities = capabilities,
    --             flags = {
    --                 debounce_text_changes = 1000,
    --             },
    --         })
    --         lspconfig.ts_ls.setup({
    --             capabilities = capabilities,
    --             -- disabling diagnostics for typescript in favor of eslint (some would overlap)
    --             -- handlers = {
    --             --     ["textDocument/publishDiagnostics"] = function() end
    --             -- }
    --         })
    --         lspconfig.yamlls.setup({
    --             capabilities = capabilities,
    --         })
    --         lspconfig.csharp_ls.setup({
    --             capabilities = capabilities,
    --         })
    --
    --         vim.api.nvim_create_autocmd("LspAttach", {
    --             group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    --
    --             callback = function(event)
    --                 -- Enable completion triggered by <c-x><c-o>
    --                 vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    --
    --                 local map = function(keys, func, desc, mode)
    --                     mode = mode or "n"
    --                     vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    --                 end
    --
    --                 -- :help vim.lsp.buf
    --                 vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    --
    --                 -- Execute a code action, usually your cursor needs to be on top of an error
    --                 -- or a suggestion from your LSP for this to activate.
    --                 map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })
    --
    --                 -- Rename the variable under your cursor.
    --                 --  Most Language Servers support renaming across files, etc.
    --                 map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    --
    --                 -- Jump to the definition of the word under your cursor.
    --                 --  This is where a variable was first declared, or where a function is defined, etc.
    --                 --  To jump back, press <C-t>.
    --                 map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    --
    --                 -- WARN: This is not Goto Definition, this is Goto Declaration.
    --                 --  For example, in C this would take you to the header.
    --                 map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    --
    --                 -- Find references for the word under your cursor.
    --                 map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    --
    --                 -- Fuzzy find all the symbols in your current document.
    --                 --  Symbols are things like variables, functions, types, etc.
    --                 map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    --
    --                 -- Fuzzy find all the symbols in your current workspace.
    --                 --  Similar to document symbols, except searches over your entire project.
    --                 map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    --
    --                 -- Jump to the implementation of the word under your cursor.
    --                 --  Useful when your language has ways of declaring types without an actual implementation.
    --                 map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    --             end
    --         })
    --     end
    -- }
}
