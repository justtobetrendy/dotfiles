vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "vim",
                    -- "Snacks",
                },
            },
        },
    },
})

vim.lsp.enable({
    -- this list should be the same as `ensure_installed`
    -- found in plugins/lsp.lua
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
})

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- vim.lsp.config('*', {
--     capabilities = capabilities,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),

    callback = function(event)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Enable completion for 0.11 native
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        -- end

        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- :help vim.lsp.buf
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame") -- 0.11 default mapping to grn

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        -- 0.11 default mapping to grr but it dispatch to quicklist suggest to change telescope to frr

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation") -- 0.11 default mapping to gri
    end
})

vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        header = false,
        -- border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
