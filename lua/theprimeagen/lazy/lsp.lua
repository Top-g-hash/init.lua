return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        -- -------------------
        -- Formatting
        -- -------------------
        require("conform").setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                vue = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 1000,
                lsp_fallback = true,
            },
        })
        -- 🔥 Format shortcut (put this RIGHT AFTER conform setup)
        vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, { desc = "Format file" })


        -- -------------------
        -- Capabilities
        -- -------------------
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- -------------------
        -- UI helpers
        -- -------------------
        require("fidget").setup({})

        -- -------------------
        -- Mason (binary installer only)
        -- -------------------
        require("mason").setup()
        -- Install tools manually once via :Mason
        -- Install:
        --   lua-language-server
        --   rust-analyzer
        --   gopls
        --   vue-language-server
        --   vtsls

        -- -------------------
        -- LSP CONFIG (NEW API)
        -- -------------------

        -- Lua
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },

        })

        -- Rust
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
        })

        -- Go
        vim.lsp.config("gopls", {
            capabilities = capabilities,
        })

        -- -------------------
        -- Vue + TypeScript
        -- -------------------

        local vue_language_server_path =
            vim.fn.stdpath("data")
            .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

        local vue_plugin = {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
        }

        -- vtsls (TypeScript engine + Vue plugin)
        vim.lsp.config("vtsls", {
            capabilities = capabilities,
            filetypes = {
                "vue",
                "typescript",
                "javascript",
                "javascriptreact",
                "typescriptreact",
            },
            settings = {
                vtsls = {
                    tsserver = {
                        globalPlugins = { vue_plugin },
                    },
                },
            },
        })

        -- vue language server (Volar)
        vim.lsp.config("vue_ls", {
            capabilities = capabilities,
        })

        -- -------------------
        -- Enable servers
        -- -------------------
        vim.lsp.enable({
            "lua_ls",
            "rust_analyzer",
            "gopls",
            "vtsls",
            "vue_ls",
        })

        -- -------------------
        -- CMP setup
        -- -------------------
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
<<<<<<< HEAD
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
=======
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
>>>>>>> b2dd1bc (LSP vue_ls & prettier conform)
            },
        })

        -- -------------------
        -- Diagnostics UI
        -- -------------------
        vim.diagnostic.config({
            float = {
                border = "rounded",
                source = "always",
            },
        })
    end,
}
