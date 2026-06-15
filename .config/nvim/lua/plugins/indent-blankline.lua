return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = function()
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local dim_highlight = {
            "RainbowRedDim",
            "RainbowYellowDim",
            "RainbowBlueDim",
            "RainbowOrangeDim",
            "RainbowGreenDim",
            "RainbowVioletDim",
            "RainbowCyanDim",
        }

        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed",       { fg = "#F38BA8" })
            vim.api.nvim_set_hl(0, "RainbowYellow",    { fg = "#F9E2AF" })
            vim.api.nvim_set_hl(0, "RainbowBlue",      { fg = "#89B4FA" })
            vim.api.nvim_set_hl(0, "RainbowOrange",    { fg = "#FAB387" })
            vim.api.nvim_set_hl(0, "RainbowGreen",     { fg = "#A6E3A1" })
            vim.api.nvim_set_hl(0, "RainbowViolet",    { fg = "#CBA6F7" })
            vim.api.nvim_set_hl(0, "RainbowCyan",      { fg = "#94E2D5" })
            vim.api.nvim_set_hl(0, "RainbowRedDim",    { fg = "#5e3648" })
            vim.api.nvim_set_hl(0, "RainbowYellowDim", { fg = "#5e5035" })
            vim.api.nvim_set_hl(0, "RainbowBlueDim",   { fg = "#33486b" })
            vim.api.nvim_set_hl(0, "RainbowOrangeDim", { fg = "#5e4235" })
            vim.api.nvim_set_hl(0, "RainbowGreenDim",  { fg = "#3a5235" })
            vim.api.nvim_set_hl(0, "RainbowVioletDim", { fg = "#4a3560" })
            vim.api.nvim_set_hl(0, "RainbowCyanDim",   { fg = "#335250" })
        end)

        return {
            indent = {
                char = "▏",  -- U+258F left one eighth block
                --char = "╎",  -- U+254E double dash vertical
                --char = "⸾",  -- U+2E3E wiggly vertical line
                --char = "⌇",  -- U+2307 wavy line
                --char = "⦚",   -- U+299A vertical zigzag line
                highlight = dim_highlight,
            },
            scope = {
                highlight = highlight,
                show_exact_scope = true,
                include = {
                    node_type = {
                        lua = {
                            "block",
                            "do_statement",
                            "else_statement",
                            "elseif_statement",
                            "for_generic_clause",
                            "for_numeric_clause",
                            "for_statement",
                            "function_declaration",
                            "function_definition",
                            "if_statement",
                            "repeat_statement",
                            "table_constructor",
                            "while_statement",
                        },
                        java = {
                            "annotation_type_body",
                            "block",
                            "catch_clause",
                            "class_body",
                            "constructor_declaration",
                            "do_statement",
                            "enhanced_for_statement",
                            "enum_body",
                            "finally_clause",
                            "for_statement",
                            "if_statement",
                            "interface_body",
                            "lambda_expression",
                            "method_declaration",
                            "record_declaration",
                            "static_initializer",
                            "switch_block",
                            "try_statement",
                            "while_statement",
                        },
                        javascript = {
                            "arrow_function",
                            "catch_clause",
                            "class",
                            "class_body",
                            "class_declaration",
                            "class_static_block",
                            "do_statement",
                            "for_in_statement",
                            "for_statement",
                            "function_declaration",
                            "function_expression",
                            "generator_function",
                            "generator_function_declaration",
                            "if_statement",
                            "jsx_element",
                            "jsx_expression",
                            "object",
                            "statement_block",
                            "switch_body",
                            "switch_statement",
                            "try_statement",
                            "while_statement",
                        },
                        typescript = {
                            "arrow_function",
                            "catch_clause",
                            "class",
                            "class_body",
                            "class_declaration",
                            "class_static_block",
                            "do_statement",
                            "enum_body",
                            "for_in_statement",
                            "for_statement",
                            "function_declaration",
                            "function_expression",
                            "generator_function",
                            "generator_function_declaration",
                            "if_statement",
                            "interface_body",
                            "module",
                            "object",
                            "statement_block",
                            "switch_body",
                            "switch_statement",
                            "try_statement",
                            "while_statement",
                        },
                        tsx = {
                            "arrow_function",
                            "catch_clause",
                            "class",
                            "class_body",
                            "class_declaration",
                            "class_static_block",
                            "do_statement",
                            "enum_body",
                            "for_in_statement",
                            "for_statement",
                            "function_declaration",
                            "function_expression",
                            "generator_function",
                            "generator_function_declaration",
                            "if_statement",
                            "interface_body",
                            "jsx_element",
                            "jsx_expression",
                            "module",
                            "object",
                            "statement_block",
                            "switch_body",
                            "switch_statement",
                            "try_statement",
                            "while_statement",
                        },
                    },
                },
            },
        }
    end,
}
