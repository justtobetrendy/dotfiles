-- For conciseness
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Navigate between splits
-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Using TmuxNavigate to navigate between splits, if not using tmux
-- use the keymaps above.
vim.keymap.set("n", "<C-k>", "<cmd>:TmuxNavigateUp<CR>", opts)
vim.keymap.set("n", "<C-j>", "<cmd>:TmuxNavigateDown<CR>", opts)
vim.keymap.set("n", "<C-h>", "<cmd>:TmuxNavigateLeft<CR>", opts)
vim.keymap.set("n", "<C-l>", "<cmd>:TmuxNavigateRight<CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
-- vim.keymap.set("n", "<leader>se", "<C-w>=", opts)     -- make split windows equal width & height
-- vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Quickfix list
-- []q now default in 0.11 but keeping the binding for description
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Diagnostic keymaps
-- []d now default in 0.11 but keeping the binding for description
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Test for linux
-- equivalent to set clipboard = unnamedplus ...
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
-- vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y')
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d')
-- vim.keymap.set({ 'n', 'v' }, '<leader>D', '"+D')
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
-- vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')
