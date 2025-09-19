return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    after = "catppuccin",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        -- local macchiato = require("catppuccin.palettes").get_palette "macchiato"

        require('bufferline').setup({
            highlights = require("catppuccin.groups.integrations.bufferline").get_theme(),
            options = {
                mode = "buffers", -- set to "tabs" to only show tabpages instead
                themable = true,  -- allows highlight groups to be overriden i.e. sets highlights as default
                numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
                -- stylua: ignore
                close_command = function(n) require('snacks').bufdelete(n) end,
                -- stylua: ignore
                right_mouse_command = function(n) require('snacks').bufdelete(n) end,
                -- buffer_close_icon = "✗",
                -- close_icon = "✗",
                path_components = 1, -- Show only the file name without the directory
                modified_icon = "●",
                left_trunc_marker = "",
                right_trunc_marker = "",
                max_name_length = 30,
                max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
                -- tab_size = 21,
                diagnostics = false,
                diagnostics_update_in_insert = false,
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = false,
                show_close_icon = false,
                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                -- separator_style = { "│", "│" }, -- | "thick" | "thin" | { 'any', 'any' },
                -- enforce_regular_tabs = true,
                always_show_bufferline = false,
                show_tab_indicators = false,
                -- indicator = {
                --     -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
                --     style = "none", -- Options: 'icon', 'underline', 'none'
                -- },
                icon_pinned = "󰐃",
                minimum_padding = 1,
                maximum_padding = 5,
                maximum_length = 15,
                sort_by = "insert_at_end",
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            }
        });

        vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle [b]uffer [p]in" })
        vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>",
            { desc = "Delete [b]uffers un[P]in" })
        vim.keymap.set("n", "<leader>bd", function() require("snacks").bufdelete() end, { desc = "[b]uffer [d]delete" })
        vim.keymap.set("n", "<leader>bo", function() require("snacks").bufdelete.other() end,
            { desc = "[b]uffer delete [o]thers" })
        vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
        vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        -- vim.keymap.set("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
        -- vim.keymap.set("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "[B", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer prev" })
        vim.keymap.set("n", "]B", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer next" })
    end
}
