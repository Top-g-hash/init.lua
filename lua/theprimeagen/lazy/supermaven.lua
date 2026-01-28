return {
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<Tab>", -- accept AI suggestion
                    clear_suggestion = "<C-]>",
                    accept_word = "<C-j>",
                },
                ignore_filetypes = { "markdown" },
                color = {
                    suggestion_color = "#888888",
                },
                log_level = "off",
            })
        end,
    },
}
