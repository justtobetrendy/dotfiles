vim.pack.add({
  "https://github.com/romus204/tree-sitter-manager.nvim",
})

require("tree-sitter-manager").setup({
  auto_install = true,
  border = "rounded",
  ensure_installed = {
    "bash",
    "blade",
    "c",
    "comment",
    "css",
    "diff",
    "dockerfile",
    "fish",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "make",
    "markdown",
    "markdown_inline",
    "nginx",
    "nix",
    "proto",
    "python",
    "query",
    "regex",
    "rust",
    "scss",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zig",
  }
})

local SKIP_FT = {
  [""] = true,
  qf = true,
  help = true,
  man = true,
  noice = true,
  notify = true,
  snacks_notif = true,
  snacks_notif_history = true,
  snacks_picker_list = true,
  snacks_picker_input = true,
  snacks_input = true,
  snacks_terminal = true,
  dapui_scopes = true,
  dapui_breakpoints = true,
  dapui_stacks = true,
  dapui_watches = true,
  dapui_console = true,
  dap_repl = true,
  gitcommit = true,
  gitrebase = true,
  lazy = true,
  lspinfo = true,
  checkhealth = true,
  startuptime = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  spectre_panel = true,
  ["grug-far"] = true,
  trouble = true,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.filetype
    if SKIP_FT[ft] then
      return
    end

    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end

    -- Only set expr folds when treesitter successfully started
    vim.wo[0].foldmethod = "expr"
    vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})
