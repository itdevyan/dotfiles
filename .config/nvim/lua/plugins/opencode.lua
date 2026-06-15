return {
    "NickvanDyke/opencode.nvim",
    version = "*", -- Latest stable release
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        {
            "folke/snacks.nvim",
            optional = true,
            opts = {
                input = {}, -- Enhances `ask()`
                picker = { -- Enhances `select()`
                    actions = {
                        -- Moved from plugin code to user config in v0.12.0.
                        opencode_send = function(picker)
                            local items = vim.tbl_map(function(item)
                                return item.file
                                    and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                                    or item.text
                            end, picker:selected({ fallback = true }))
                            require("opencode").prompt(table.concat(items, ", ") .. " ")
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                            },
                        },
                    },
                },
                terminal = {},
            },
        },
    },
    config = function()
        local opencode_cmd = "opencode --port"
        local snacks_term_opts = {
            win = { position = "right", enter = false },
        }

        ---@type opencode.Opts
        vim.g.opencode_opts = {
            -- server.toggle removed in v0.11.0; use snacks.terminal for toggle.
            server = {
                start = function()
                    require("snacks.terminal").open(opencode_cmd, snacks_term_opts)
                end,
            },
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<C-o>", function()
            require("opencode").ask("@this:")
        end, { desc = "Ask opencode" })
        vim.keymap.set({ "n", "x" }, "<C-x>", function()
            require("opencode").select()
        end, { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "t" }, "<C-.>", function()
            require("snacks.terminal").toggle(opencode_cmd, snacks_term_opts)
        end, { desc = "Toggle opencode" })

        vim.keymap.set({ "n", "x" }, "go", function()
            return require("opencode").operator("@this ")
        end, { expr = true, desc = "Add range to opencode" })
        vim.keymap.set("n", "goo", function()
            return require("opencode").operator("@this ") .. "_"
        end, { expr = true, desc = "Add line to opencode" })

        vim.keymap.set("n", "<S-C-u>", function()
            require("opencode").command("session.half.page.up")
        end, { desc = "opencode half page up" })
        vim.keymap.set("n", "<S-C-d>", function()
            require("opencode").command("session.half.page.down")
        end, { desc = "opencode half page down" })

        -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
        --vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
        --vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
}
