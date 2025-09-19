return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" },                   -- or github/copilot.vim
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken",                            -- Only on MacOS or Linux
        opts = {
            -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
    {
        "zbirenbaum/copilot.lua", -- or "github/copilot.vim"
        opts = {
            panel = { enabled = false },
            suggestion = {
                auto_trigger = false, -- Suggest as we start typing
            },
        },
    }
    -- {
    --     "olimorris/codecompanion.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --         "zbirenbaum/copilot.lua", -- or "github/copilot.vim"
    --     },
    --     opts = {
    --         adapters = {
    --             -- copilot = function()
    --             --     return require("codecompanion.adapters").extend("copilot", {
    --             --         schema = {
    --             --             model = {
    --             --                 default = "claude-3.5-sonnet",
    --             --             },
    --             --         },
    --             --     })
    --             -- end,
    --             ollama = function()
    --                 return require("codecompanion.adapters").extend("ollama", {
    --                     schema = {
    --                         model = {
    --                             default = 'qwen2.5-coder:3b'
    --                         },
    --                         num_ctx = {
    --                             default = 20000,
    --                         },
    --                     },
    --                 })
    --             end,
    --         },
    --         strategies = {
    --             chat = {
    --                 adapter = "copilot",
    --             },
    --             inline = {
    --                 adapter = "copilot",
    --             },
    --             agent = {
    --                 adapter = "copilot",
    --             }
    --         },
    --         prompt_library = {
    --             ["Code Expert"] = {
    --                 strategy = "chat",
    --                 description = "Get some special advice from an LLM",
    --                 opts = {
    --                     mapping = "<LocalLeader>ce",
    --                     modes = { "v" },
    --                     short_name = "expert",
    --                     auto_submit = true,
    --                     stop_context_insertion = true,
    --                     user_prompt = true,
    --                 },
    --                 prompts = {
    --                     {
    --                         role = "system",
    --                         content = function(context)
    --                             return "I want you to act as a senior "
    --                                 .. context.filetype
    --                                 .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
    --                         end,
    --                     },
    --                     {
    --                         role = "user",
    --                         content = function(context)
    --                             local text = require("codecompanion.helpers.actions").get_code(context.start_line,
    --                                 context.end_line)
    --
    --                             return "I have the following code:\n\n```" ..
    --                                 context.filetype .. "\n" .. text .. "\n```\n\n"
    --                         end,
    --                         opts = {
    --                             contains_code = true,
    --                         }
    --                     },
    --                 },
    --             },
    --         },
    --     }
    -- },
}
