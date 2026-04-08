vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")

Snacks.setup({
  animate = { enabled = false },
  bigfile = {
    enabled = true,
    size = 1.5 * 1024 * 1024, -- 1.5MB threshold
    setup = function(ctx)
      -- Disable treesitter (disables highlights, folds, indentexpr)
      vim.cmd("syntax clear")
      vim.treesitter.stop(ctx.buf)
      vim.wo[0].foldmethod = "manual"
      vim.wo[0].foldexpr = ""

      -- Disable LSP features that are expensive on large files
      vim.schedule(function()
        vim.lsp.inlay_hint.enable(false, { bufnr = ctx.buf })
        vim.lsp.document_color.enable(false, ctx.buf)
      end)

      -- Keep diagnostics off for huge files
      vim.diagnostic.enable(false, { bufnr = ctx.buf })

      -- Disable indent guides
      vim.b[ctx.buf].snacks_indent = false
    end,
  },
  dashboard = { enabled = false },
  dim = { enabled = false },
  explorer = { enabled = true, replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = {
    enabled = true,
    only_scope = true,    -- only show indent guides of the scope
    only_current = false, -- only show indent guides in the current window
  },
  input = { enabled = false },
  layout = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = true },
  scope = { enabled = false },
  scratch = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  terminal = { enabled = false },
  toggle = { enabled = false },
  words = { enabled = false }, -- was false
  zen = { enabled = false },

  picker = {
    sources = {
      files = {
        hidden = true,
        ignored = false,
        win = {
          input = {
            keys = {
              ["<S-h>"] = "toggle_hidden",
              ["<S-i>"] = "toggle_ignored",
              ["<S-f>"] = "toggle_follow",
              ["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
            },
          },
        },
        exclude = {
          "**/.git/*",
          "**/node_modules/*",
          "**/.yarn/cache/*",
          "**/.yarn/install*",
          "**/.yarn/releases/*",
          "**/.pnpm-store/*",
          "**/.idea/*",
          "**/.DS_Store",
          "**/.venv/**",
          "build/*",
          "coverage/*",
          "dist/*",
          "hodor-types/*",
          "**/target/*",
          "**/public/*",
          "**/.node-gyp/**",
          "**/claude/debug",
          "**/claude/file-history",
          "**/claude/plans",
          "**/claude/plugins",
          "**/claude/projects",
          "**/claude/session-env",
          "**/claude/shell-snapshots",
          "**/claude/statsig",
          "**/claude/telemetry",
          "**/claude/todos",
          "**/claude/history.jsonl",
          "**/claude/*cache*",
        },
      },
      grep = {
        hidden = true,
        ignored = false,
        win = {
          input = {
            keys = {
              ["<S-h>"] = "toggle_hidden",
              ["<S-i>"] = "toggle_ignored",
              ["<S-f>"] = "toggle_follow",
            },
          },
        },
        exclude = {
          "**/.git/*",
          "**/node_modules/*",
          "**/.yarn/cache/*",
          "**/.yarn/install*",
          "**/.yarn/releases/*",
          "**/.pnpm-store/*",
          "**/.venv/*",
          "**/.idea/*",
          "**/.DS_Store",
          "**/.venv/**",
          "**/yarn.lock",
          "build*/*",
          "coverage/*",
          "dist/*",
          "certificates/*",
          "hodor-types/*",
          "**/target/*",
          "**/public/*",
          "**/digest*.txt",
          "**/.node-gyp/**",
          "**/claude/debug",
          "**/claude/file-history",
          "**/claude/plans",
          "**/claude/plugins",
          "**/claude/projects",
          "**/claude/session-env",
          "**/claude/shell-snapshots",
          "**/claude/statsig",
          "**/claude/telemetry",
          "**/claude/todos",
          "**/claude/history.jsonl",
          "**/claude/*cache*",
        },
      },
      grep_buffers = {},
      explorer = {
        hidden = false,
        ignored = false,
        supports_live = true,
        auto_close = false,
        diagnostics = true,
        diagnostics_open = false,
        focus = "list",
        follow_file = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
        jump = { close = true },
        tree = true,
        watch = true,
        exclude = {
          -- ".git",
          ".yarn/cache/**",
          ".yarn/install/**",
          ".yarn/install*",
          ".yarn/releases/**",
          ".pnpm-store",
          ".venv",
          ".DS_Store",
          "**/.node-gyp/**",
          "**/claude/debug",
          "**/claude/file-history",
          "**/claude/plans",
          "**/claude/plugins",
          "**/claude/projects",
          "**/claude/session-env",
          "**/claude/shell-snapshots",
          "**/claude/statsig",
          "**/claude/telemetry",
          "**/claude/todos",
          "**/claude/history.jsonl",
          "**/claude/*cache*",
        },
      },
    },
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true, -- run exactly once
  callback = function()
    -- Run after everything is loaded — safe with vim.pack
    vim.schedule(function()
      -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle
          .option("conceallevel", {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
            name = "Conceal Level",
          })
          :map("<leader>uc")
      Snacks.toggle
          .option("showtabline", {
            off = 0,
            on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
            name = "Tabline",
          })
          :map("<leader>uA")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
      Snacks.toggle.dim():map("<leader>uD")
      Snacks.toggle.animate():map("<leader>ua")
      Snacks.toggle.indent():map("<leader>ug")
      Snacks.toggle.scroll():map("<leader>uS")
      Snacks.toggle.profiler():map("<leader>dpp")
      Snacks.toggle.profiler_highlights():map("<leader>dph")
      Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
      Snacks.toggle.zen():map("<leader>uz")
    end)
  end,
})

-- stylua: ignore start
local keymaps = {
  -- { "<leader>l",       function() vim.cmd("Lazy") end,                 desc = "Open Lazy tab", },
  -- Top Pickers & Explorer
  -- { "<leader><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
  { "<leader><space>", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
  { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
  { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
  { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
  { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
  -- {
  --   "<leader>,",
  --   function()
  --     Snacks.picker.buffers({
  --       win = {
  --         input = {
  --           keys = {
  --             ["dd"] = "bufdelete",
  --             ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
  --           },
  --         },
  --         list = { keys = { ["dd"] = "bufdelete" } },
  --       },
  --     })
  --   end,
  --   desc = "Buffers",
  -- },
  -- find
  -- replaced with leader-space
  -- { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
  { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
  { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
  -- { "<leader>fg", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
  -- { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
  { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
  { "<leader>fs",      function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
  -- git
  -- { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
  -- { "<leader>gl", function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
  -- { "<leader>gL", function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
  -- { "<leader>gs", function() Snacks.picker.git_status() end,                              desc = "Git Status" },
  -- { "<leader>gS", function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
  -- { "<leader>gp", function() Snacks.picker.git_diff() end,                                desc = "Git Diff Picker (Hunks)" },
  -- { "<leader>gP", function() Snacks.picker.git_diff({ base = "origin" }) end,             desc = "Git Diff Picker (origin)" },
  -- { "<leader>gf", function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
  -- Grep
  { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
  -- { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
  { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
  { "<leader>sG",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
  -- { "<leader>sw", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
  -- search
  { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
  { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
  { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
  { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
  -- { "<leader>sC", function() Snacks.picker.commands() end,                                desc = "Commands" },
  { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
  { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
  -- { "<leader>sH", function() Snacks.picker.highlights() end,                              desc = "Highlights" },
  { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
  { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
  { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
  { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
  { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
  { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
  { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
  -- { "<leader>sR", function() Snacks.picker.resume() end,                                  desc = "Resume" },
  { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
  -- { "<leader>uC", function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
  -- buffers
  { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete buffer",            mode = { "n" }, },
  { "<leader>bo",      function() Snacks.bufdelete.other() end,                                desc = "Delete other buffers",     mode = { "n" }, },
  -- terminal
  -- { "<leader>fT", function() Snacks.terminal() end,                                       desc = "Terminal (cwd)",           mode = "n", },
  -- { "<leader>ft", function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end,         desc = "Terminal (Root Dir)",      mode = "n", },
  -- { "<c-_>",      function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end,         desc = "which_key_ignore",         mode = "n", },
  -- Other
  -- { "<leader>z",  function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
  -- { "<leader>Z",  function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
  { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
  { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
  { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
  -- { "<leader>cR", function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
  -- { "<leader>gB", function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
  -- { "<leader>gg", function() Snacks.lazygit() end,                                        desc = "Lazygit" },
  { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
  -- { "<c-_>",      function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
  -- { "]]",         function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
  -- { "[[",         function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },
  {
    "<leader>N",
    desc = "Neovim News",
    function()
      Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
          spell = false,
          wrap = false,
          signcolumn = "yes",
          statuscolumn = " ",
          conceallevel = 3,
        },
      })
    end,
  }
}
-- stylua: ignore end
for _, map in ipairs(keymaps) do
  local opts = { desc = map.desc }
  if map.silent ~= nil then
    opts.silent = map.silent
  end
  if map.noremap ~= nil then
    opts.noremap = map.noremap
  else
    opts.noremap = true
  end
  if map.expr ~= nil then
    opts.expr = map.expr
  end

  local mode = map.mode or "n"
  vim.keymap.set(mode, map[1], map[2], opts)
end
